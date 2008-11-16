# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :translate_familiar_names
 
  def translate_familiar_names
	if params[:fn_project]
		project = Project.find(:first, :conditions => { :title => params[:fn_project] } )
		params.delete(:fn_project)
		params[:project_id] = project ? project.id : -1
		params[:id] ||= params[:project_id]
	end
	if params[:fn_user]
		user = User.find(:first, :conditions => { :nickname => params[:fn_user] } )
		params.delete(:fn_user)
		params[:user_id] = user ? user.id : -1
		params[:id] ||= params[:user_id]
	end
  end 
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c5ba5e1acec38ffd3674baece8fd4978'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  helper_method :current_user
  helper_method :current_project
  protected
  def current_user
	@current_user ||= ( session[:user_id] && User.find_by_id( session[:user_id]))
  end
  
  def current_user= ( new_user )
	session[:user_id] = new_user && new_user.id
	@current_user = new_user
	
	if @current_user
		favs = @current_user.favorite_projects(1)
		unless favs.empty?
			self.current_project = @current_user.favorite_projects.unshift
		end
	end
  end
  
  def current_project
	@current_project ||= ( session[:project_id] && Project.find_by_id( session[:project_id]))
  end
  
  def current_project= ( new_project )
	session[:project_id] = new_project && new_project.id
	@current_project = new_project
  end
  
  def successful_login
	redirect_to :controller => 'welcome'
  end
  
  def require_login
	unless current_user
		redirect_to :controller => 'session', :action => 'new'
	end
  end
  
  def require_admin_login
	unless current_user && current_user.is_admin
		redirect_to :controller => 'session', :action => 'unauthorized'
	end
  end
  
end