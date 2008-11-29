class DocumentReview < ActiveRecord::Base
	before_save :add_disposition_timestamp
	
	belongs_to :document
	belongs_to :stage_reviewer
	has_many :document_review_reasons, :dependent => :delete_all
	has_many :reasons, :through => :document_review_reasons
	has_many :preceding_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE stage_reviewer_id = #{stage_reviewer_id} AND ((reviewer_sequence + reviewer_snooze) < #{reviewer_sequence + reviewer_snooze} OR ((reviewer_sequence + reviewer_snooze) = #{reviewer_sequence + reviewer_snooze} AND id < #{id})) ORDER BY (reviewer_sequence + reviewer_snooze) DESC, id DESC'
	has_many :following_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE stage_reviewer_id = #{stage_reviewer_id} AND ((reviewer_sequence + reviewer_snooze) > #{reviewer_sequence + reviewer_snooze} OR ((reviewer_sequence + reviewer_snooze) = #{reviewer_sequence + reviewer_snooze} AND id > #{id})) ORDER BY (reviewer_sequence + reviewer_snooze) ASC, id ASC'
	
	def when_assigned
		self.created_at
	end
	
	def when_assigned=( datetime )
		self.created_at = datetime
	end
	
	def add_disposition_timestamp
		self.when_reviewed ||= Time.now if self.attribute_present?(:disposition)
	end
	
	def includes_reason?( reason )
		return self.reasons.include?( reason )
	end
	
	def self.disposition( code )
		return case code
			when 'I'
				'Included'
			when 'E'
				'Excluded'
			else
				code
		end
	end

	def self.action_verb( code )
		return case code
			when 'I'
				'included'
			when 'E'
				'excluded'
			else
				'is reviewing'
		end
	end
	
	def complete?()
		return ! self.incomplete?
	end

	def incomplete?()
		return self.disposition.nil?
	end
	
end
