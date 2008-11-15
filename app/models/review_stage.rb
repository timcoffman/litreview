class ReviewStage < ActiveRecord::Base
	belongs_to :project
	has_many :stage_reviewers
	has_many :users, :through => :stage_reviewers
	has_many :reviewers, :class_name => 'User', :source => :user, :through => :stage_reviewers
	has_many :reasons
	has_many :custom_reasons, :class_name => 'Reason', :conditions => [ 'created_by_stage_reviewer_id IS NOT NULL' ]
	has_many :document_reviews, :through => :stage_reviewers
	has_many :document_tags, :class_name => 'DocumentTag', :foreign_key => :applied_in_review_stage_id
	
	has_many :included_documents, :class_name => 'Document', :finder_sql => <<-EOT
		SELECT * FROM documents d
			WHERE 0 < (
				SELECT COUNT(dr.stage_reviewer_id)
				FROM document_reviews dr
				LEFT JOIN stage_reviewers sr ON dr.stage_reviewer_id = sr.id
				WHERE dr.document_id = d.id AND sr.review_stage_id = 215 AND dr.disposition = 'I'
				GROUP BY dr.document_id
				)
		EOT
	
	def previous_stage
		return self.project.review_stages.find(:first, :conditions => { :sequence => (self.sequence - 1) } )
	end
	
	def reviewed_by?( user )
		return user && self.users.find(:first, :conditions => { :id => user.id } )
	end
	
	def reviewable_documents
		if self.gate_function == 'ANY'
			return []
		elsif self.gate_function == 'ALL'
			return []
		else
			return []
		end
	end

	def self.gate_noun( code )
		case code
			when 'ALL'
				'documents included by all reviewers'
			when 'ANY'
				'documents included by any reviewer'
			else
				code
		end
	end

	def new_report( spec ={} )
		return self.report( spec ) 
	end
end
