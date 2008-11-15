class DocumentReviewReason < ActiveRecord::Base
	belongs_to :document_review ;
	belongs_to :reason ;
end
