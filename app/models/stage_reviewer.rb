class StageReviewer < ActiveRecord::Base
	belongs_to :review_stage
	belongs_to :user
	has_many :document_reviews
	has_many :documents, :through => :document_reviews
	has_many :incomplete_reviews, :class_name => 'DocumentReview', :conditions => [ 'disposition IS NULL' ], :order => "reviewer_sequence + reviewer_snooze DESC"
	has_many :completed_reviews, :class_name => 'DocumentReview', :conditions => [ 'disposition IS NOT NULL' ], :order => "reviewer_sequence + reviewer_snooze ASC"
	has_many :custom_reasons, :class_name => 'Reason', :foreign_key => 'created_by_stage_reviewer_id'
end
