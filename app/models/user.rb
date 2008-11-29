class User < ActiveRecord::Base
	has_many :stage_reviewers, :dependent => :delete_all
	has_many :review_stages, :through => :stage_reviewers
	has_many :managers, :dependent => :delete_all
	has_many :managed_projects, :class_name => 'Project', :source => :project, :through => :managers
	has_one :current_project, :class_name => 'Project', :foreign_key => 'current_project_id'
	has_many :custom_tags, :class_name => 'Tag', :foreign_key => :created_by_user_id, :dependent => :nullify
	has_many :document_tags, :class_name => 'DocumentTag', :foreign_key => :applied_by_user_id, :dependent => :nullify

	validates_presence_of :identity_url
	
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
	
	def preference( name )
		# this should read a user preferences table for the preference with the given name
		return 'default' ;
	end
end
