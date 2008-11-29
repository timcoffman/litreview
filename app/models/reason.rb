class Reason < ActiveRecord::Base
	belongs_to :review_stage
	belongs_to :created_by_stage_reviewer, :class_name => 'StageReviewer', :foreign_key => 'created_by_stage_reviewer_id'
	has_many :document_review_reasons, :dependent => :delete_all
	has_many :document_reviews, :through => :document_review_reasons
end
