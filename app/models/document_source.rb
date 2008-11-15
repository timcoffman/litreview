class DocumentSource < ActiveRecord::Base
	belongs_to :project
	has_many :documents
end
