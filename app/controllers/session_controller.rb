class SessionController < ApplicationController
	
	skip_before_filter :verify_authenticity_token
	
	def force
		self.current_user = User.find(params[:id])
		redirect_to user_path(self.current_user)
	end
	
	def new
		
	end

	def create
		open_id_authentication
	end
	
	def destroy
		reset_session
		self.current_user = nil
		flash[:notice] = 'You have logged out'
		render :action => 'new'
	end
	
	def open_id_authentication
		if params[:openid_url].blank? && params[:open_id_complete].blank?
			return failed_login("Please enter your OpenId") ;
		end
		
		@openid_url = params[:openid_url] ;
		
		authenticate_with_open_id(
				@openid_url,
				:required => [ :email ],
				:optional => [ :fullname, :nickname ]
			) do |result, identity_url, registration|
			
			if result.successful?
				user = User.find_by_identity_url( identity_url )
				if user.nil?
					user = User.new( :identity_url => identity_url )
					unless assign_registration_attributes( user, registration )
						return failed_login( "Your OpenID registration failed: " + user.errors.full_messages.to_sentence )
					end
				end
				self.current_user = user ;
				successful_login
			else
				failed_login( result.message || "Sorry, couldn't authenticate #{identity_url}" )
			end
		end
	end
	
	def failed_login( message )
		flash[:error] = message
		render :action => 'new'
	end
	
	def assign_registration_attributes( user, registration )
		{
			:email => 'email',
			:full_name => 'fullname',
			:nickname => 'nickname'
		}.each do |model_attr, registration_attr|
			unless registration[registration_attr].blank?
				user.send "#{model_attr}=", registration[registration_attr]
			end
		end
		user.save
	end
	
	def switch_project
		project = Project.find(params[:id])
		self.current_project = project
		redirect_to user_project_url( current_user, project )
	end
end
