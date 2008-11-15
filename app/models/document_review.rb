class DocumentReview < ActiveRecord::Base
	belongs_to :document
	belongs_to :stage_reviewer
	has_many :document_review_reasons
	has_many :reasons, :through => :document_review_reasons
	has_many :preceding_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE (reviewer_sequence + reviewer_snooze) <= #{reviewer_sequence + reviewer_snooze} AND id <> #{id} ORDER BY (reviewer_sequence + reviewer_snooze) DESC, id DESC'
	has_many :following_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE (reviewer_sequence + reviewer_snooze) > #{reviewer_sequence + reviewer_snooze} ORDER BY (reviewer_sequence + reviewer_snooze) ASC, id ASC'
	
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
