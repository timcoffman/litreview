class Tag < ActiveRecord::Base
	has_many :document_tags
	has_many :documents, :through => :document_tags
	belongs_to :user, :foreign_key => :created_by_user_id
	belongs_to :project, :foreign_key => :created_for_project_id
	
	def self.find_best( words, user =nil, project =nil )
		self.find( :first, :conditions => { :words => words, :created_by_user_id => user, :created_for_project_id => project } ) ||
		self.find( :first, :conditions => { :words => words, :created_by_user_id => user, :created_for_project_id => nil     } ) ||
		self.find( :first, :conditions => { :words => words, :created_by_user_id => nil,  :created_for_project_id => project } ) ||
		self.find( :first, :conditions => { :words => words, :created_by_user_id => nil,  :created_for_project_id => nil     } ) ||
		self.find( :first, :conditions => { :words => words, :created_by_user_id => user                                  } ) ||
		self.find( :first, :conditions => { :words => words,                           :created_for_project_id => project } ) ||
		self.find( :first, :conditions => { :words => words                                                            } )
	end
end
