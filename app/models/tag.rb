class Tag < ActiveRecord::Base
	has_many :document_tags
	has_many :documents, :through => :document_tags
	belongs_to :user, :foreign_key => :created_by_user_id
	belongs_to :project, :foreign_key => :created_for_project_id
end
