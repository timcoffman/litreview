class StageReviewer < ActiveRecord::Base
	belongs_to :review_stage
	belongs_to :user
	has_many :document_reviews, :dependent => :delete_all
	has_many :documents, :through => :document_reviews
	has_many :incomplete_reviews, :class_name => 'DocumentReview', :conditions => [ 'disposition IS NULL' ], :order => "reviewer_sequence + reviewer_snooze ASC, id ASC"
	has_many :completed_reviews, :class_name => 'DocumentReview', :conditions => [ 'disposition IS NOT NULL' ], :order => "reviewer_sequence + reviewer_snooze ASC, id ASC"
	has_many :custom_reasons, :class_name => 'Reason', :foreign_key => 'created_by_stage_reviewer_id', :dependent => :nullify
	
	def tasks_for( user )
		return [] unless self.user == user
		return [ CompleteReviewsTask.new( self.user, self.incomplete_reviews.count, self.document_reviews.count ) ] if self.incomplete_reviews.count < self.document_reviews.count
		return []
	end
	
	
	class CompleteReviewsTask < Task
		def initialize( user, count, total )
			super(user)
			@count = count
		end
		def description
			"complete #{@count} of #{@total} document reviews"
		end
	end
end
