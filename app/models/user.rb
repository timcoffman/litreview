class User < ActiveRecord::Base
	has_many :stage_reviewers, :dependent => :delete_all
	has_many :review_stages, :through => :stage_reviewers
	has_many :managers, :dependent => :delete_all
	has_many :managed_projects, :class_name => 'Project', :source => :project, :through => :managers
	has_one :current_project, :class_name => 'Project', :foreign_key => 'current_project_id'
	has_many :custom_tags, :class_name => 'Tag', :foreign_key => :created_by_user_id, :dependent => :nullify
	has_many :document_tags, :class_name => 'DocumentTag', :foreign_key => :applied_by_user_id, :dependent => :nullify
	has_many :user_preferences

	validates_presence_of :identity_url, :nickname, :full_name, :email
	validates_format_of :email, :with => /[^@]+@[^@]+/, :message => "must be like \"name@domain.net\""
	validates_format_of :nickname, :with => /^\S+$/, :message => "can't contain spaces"
	
	def method_missing( method_sym, *args )
		m = method_sym.to_s.match( /^preferred_([^=?!]+)(=?)$/ )
		if m
			name = m[1].gsub( /_/, "." )
			unless m[2].empty?
				return self.put_preference( name, args[0] )
			else
				return self.get_preference( name )
			end
		else
			return super
		end
	end
	
	def after_initialize
		autoPromoteToAdmin = 0 == User.count
		self.is_admin ||= autoPromoteToAdmin
	end
	
	def manages?( project )
		return project && self.managers.exists?( :project_id => project.id )
	end
	
	def manager_for( project )
		return project && self.managers.find_by_project_id( :first, project.id )
	end
	
	def assign_management( project )
		return unless project
		project.assign_manager( self )
	end
	
	def revoke_management( project )
		return unless project
		project.revoke_manager( self )
	end
	
	def favorite_projects( limit =1 )
		favs = []
		if self.is_admin
			favs.concat Project.all(:limit => limit )
		else
			favs.concat self.managed_projects
			self.review_stages.inject(favs) { |f,rs| f << rs.project }
			favs.uniq!
		end
		return favs[0,limit]
	end
	
	def participates_in?( project )
		return self.managers.find( :first, :conditions => { :project_id => project.id } ) || self.review_stages.find( :first, :conditions => { :project_id => project.id } )
	end
	
	def self.default_preference_from_options( user, options )
		if options.nil?
			nil
		elsif options.is_a?(Hash)
			default = options[:default]
			if default.nil?
				nil
			elsif default.is_a?(Proc)
				default.call(user)
			else
				default.to_s
			end
		else
			options.to_s
		end
	end
	
	def get_preference( name )
		pref = self.user_preferences.find( :first, :conditions => { :key => name } )
		return pref ? pref.value : nil
	end
	
	def put_preference( name, value )
		pref = self.user_preferences.find( :first, :conditions => { :key => name } )
		pref ||= self.user_preferences.build( :key => name )
		pref.value = value
		pref.save
		return pref.value
	end
	
	def self.preference( user, name, options =nil )
		return user ? user.preference( name, options ) : User.default_preference_from_options( self, options )
	end
	
	def preference( name, options =nil )
		options ||= {}
		# this should read a user preferences table for the preference with the given name
		pref = self.user_preferences.find( :first, :conditions => { :key => name } )
		return pref ? pref.value : User.default_preference_from_options( self, options )
	end
end
