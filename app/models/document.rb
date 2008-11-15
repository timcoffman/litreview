class Document < ActiveRecord::Base
	belongs_to :document_source
	has_many :document_reviews
	has_many :stage_reviewers, :through => :document_reviews
	has_many :duplicate_documents, :class_name => 'Document', :foreign_key => :duplicate_of_document_id 
	belongs_to :duplicate_of_document, :class_name => 'Document', :foreign_key => :duplicate_of_document_id
	has_many :document_tags
	has_many :tags, :through => :document_tags
end
