class DocumentReview < ActiveRecord::Base
	before_save :add_disposition_timestamp
	
	belongs_to :document
	belongs_to :stage_reviewer
	has_many :document_review_reasons, :dependent => :delete_all
	has_many :reasons, :through => :document_review_reasons
	has_many :preceding_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE stage_reviewer_id = #{stage_reviewer_id} AND ((reviewer_sequence + reviewer_snooze) < #{reviewer_sequence + reviewer_snooze} OR ((reviewer_sequence + reviewer_snooze) = #{reviewer_sequence + reviewer_snooze} AND id < #{id})) ORDER BY (reviewer_sequence + reviewer_snooze) DESC, id DESC'
	has_many :following_siblings, :class_name => 'DocumentReview', :finder_sql => 'SELECT * FROM document_reviews WHERE stage_reviewer_id = #{stage_reviewer_id} AND ((reviewer_sequence + reviewer_snooze) > #{reviewer_sequence + reviewer_snooze} OR ((reviewer_sequence + reviewer_snooze) = #{reviewer_sequence + reviewer_snooze} AND id > #{id})) ORDER BY (reviewer_sequence + reviewer_snooze) ASC, id ASC'
  belongs_to :form, :class_name => 'ReviewForm'
  has_many :form_questions, :class_name => 'ReviewFormQuestion', :through => :form
  has_many :form_answers, :class_name => 'ReviewFormAnswer', :dependent => :destroy
	
	before_validation :remove_blank_fields
	
	validates_inclusion_of :disposition, :in => [ 'I', 'E' ], :allow_nil => true
	validates_presence_of :reasons, :if => Proc.new { |dr| dr.disposition == 'E' }
	validate :abscence_of_reasons, :if => Proc.new { |dr| dr.disposition == 'I' }

	def abscence_of_reasons
		errors.add_to_base("Document Review must not have exclusion reasons if it is included") if !reasons.empty?
	end

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

	def remove_blank_fields
		self.disposition = nil if self.disposition.blank?
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
