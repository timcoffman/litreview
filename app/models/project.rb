class Project < ActiveRecord::Base
	has_many :document_sources
	has_many :documents, :through => :document_sources
	has_many :reviewable_documents, :class_name => 'Document', :through => :document_sources, :source => :documents, :conditions => [ 'duplicate_of_document_id IS NULL' ]
	has_many :review_stages
	has_many :managers
	has_many :managing_users, :class_name => 'User', :source => :user, :through => :managers
	has_many :custom_tags, :class_name => 'Tag', :foreign_key => :created_for_project_id

	validates_presence_of :title
	
	def administered_by?( user )
		return user && user.is_admin
	end
	
	def managed_by?( user )
		return user && self.managing_users.find( :first, :conditions => { :id => user.id } )
	end
		
	def assign_manager( user )
		return unless user
		manager = self.managers.find( :first, :user_id => user.id )
		unless manager
			manager = self.managers.create( :user_id => user.id )
		end
		return manager
	end

	def revoke_manager( user )
		return unless user
		if manager = Managers.find_by_project_id_and_user_id( self, user )
			Managers.destroy( manager.id )
		end
	end
	
	def keywords
		return [ 'workflow', 'workflow analysis', 'workflow analyses', 'workflow system' ]
	end
	
	def new_report( spec ={} )
		domain = [ 'Reviewer 1 Round 1 Disposition', 'Reviewer 1 Round 2 Disposition', 'Reviewer 2 Round 1 Disposition', 'Reviewer 2 Round 2 Disposition' ]
		series = []
		return Report.new( spec ) 
	end
	
end