class ReviewStage < ActiveRecord::Base
	belongs_to :project
	has_many :stage_reviewers, :dependent => :delete_all
	has_many :users, :through => :stage_reviewers
	has_many :reviewers, :class_name => 'User', :source => :user, :through => :stage_reviewers
	has_many :reasons, :dependent => :delete_all, :order => 'sequence ASC, created_at ASC'
	has_many :custom_reasons, :class_name => 'Reason', :conditions => [ 'created_by_stage_reviewer_id IS NOT NULL' ]
	has_many :document_reviews, :through => :stage_reviewers
	has_many :document_tags, :class_name => 'DocumentTag', :foreign_key => :applied_in_review_stage_id, :dependent => :nullify
  has_one :form, :class_name => 'ReviewForm', :dependent => :destroy
	
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
      return self.document_reviews.find( :all, :conditions => { :disposition => 'I' }, :group => "document_id HAVING count(*) > 0" ).collect(&:document)
    elsif self.gate_function == 'ALL'
      n = self.stage_reviewers.size 
			return self.document_reviews.find( :all, :conditions => { :disposition => 'I' }, :group => "document_id HAVING count(*) = #{n}" ).collect(&:document)
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
	
	def auto_assign( options ={} )
		options = { :confirm => false }.merge( options || {} )
		limit = options[:limit] || {}
		result = { :status => :ok, :reviewers => { }, :added => [], :existing => [] }
		self.stage_reviewers.each { |sr| result[:reviewers][sr.id] = [] }
		docs = []
		if self.previous_stage
			docs.concat self.previous_stage.reviewable_documents
		else
			if per_source_limit = limit[:source]
				self.project.document_sources.each do |document_source|
					per_source_docs = document_source.documents.find( :all, :conditions => 'duplicate_of_document_id IS NULL').partition { |d| d.document_reviews.empty? }
					docs.concat per_source_docs[1]
					docs.concat per_source_docs[0].first( [per_source_limit.to_i - per_source_docs[1].size,0].max )
				end
			else
				docs.concat self.project.documents.find( :all, :conditions => 'duplicate_of_document_id IS NULL' )
			end
		end
		docs.reject(&:nil?).each do |doc|
			for sr in self.stage_reviewers
				dr = doc.document_reviews.find( :first, :conditions => { :stage_reviewer_id => sr.id } )
				if dr
					result[:existing] << dr
				else
					if options[:confirm]
						dr = doc.document_reviews.create( :stage_reviewer => sr )
					else
						dr = doc.document_reviews.build( :stage_reviewer => sr )
						result[:status] = :followup
					end
					result[:added] << dr
				end
				result[:reviewers][sr.id] << dr
			end
		end
		return result
	end
	
	#define_report 'agreement', :count => :documents
	
	def agreement_report
		report = ActiveReporting::Report.new( { :title => "Review Stage Agreement", :description => "Comparison of document dispositions across reviewers" } )
		for sr in self.stage_reviewers do
			report.columns << ActiveReporting::Report::Column.new( :title => "Reviewer #{sr.user.nickname}", :formatter => Proc.new { |v| DocumentReview.action_verb(v) } )
		end
		report.columns << ActiveReporting::Report::Column.new( :title => "Count" )
		sql_select1 = self.stage_reviewers.collect{ |sr| "dr#{sr.id}.disposition disposition#{sr.id}" }.join(", ")
		sql_join1 = self.stage_reviewers.collect{ |sr| "LEFT JOIN stage_reviewers sr#{sr.id} ON sr#{sr.id}.review_stage_id = rs.id AND sr#{sr.id}.id = #{sr.id}" }.join("\n")
		sql_join2 = self.stage_reviewers.collect{ |sr| "LEFT JOIN document_reviews dr#{sr.id} ON dr#{sr.id}.stage_reviewer_id = sr#{sr.id}.id AND dr#{sr.id}.document_id = d.id" }.join("\n")
		sql_where1 = self.stage_reviewers.collect{ |sr| "dr#{sr.id}.id IS NOT NULL" }.join(" OR ")
		sql_group1 = self.stage_reviewers.collect{ |sr| "dr#{sr.id}.disposition" }.join(", ")
		# SELECT dr101.disposition disp202, dr202.disposition disp202, count(d.id)
		# FROM review_stages rs, documents d
		# LEFT JOIN stage_reviewers sr101 ON sr101.review_stage_id = rs.id AND sr101.id = 101
		# LEFT JOIN stage_reviewers sr202 ON sr202.review_stage_id = rs.id AND sr202.id = 202
		# LEFT JOIN document_reviews dr101 ON dr101.stage_reviewer_id = sr101.id AND dr101.document_id = d.id
		# LEFT JOIN document_reviews dr202 ON dr202.stage_reviewer_id = sr202.id AND dr202.document_id = d.id
		# GROUP BY dr101.disposition, dr202.disposition
		# WHERE rs.id = #{self.id} AND (dr101.id NOT NULL OR dr202.id NOT NULL)
		sql = <<-EOT
			SELECT
				#{sql_select1},
				COUNT(d.id) document_count
				FROM review_stages rs JOIN documents d
				LEFT JOIN document_sources ds ON d.document_source_id = ds.id
				#{sql_join1}
				#{sql_join2}
				WHERE rs.id = #{self.id} AND ds.project_id = rs.project_id  AND (#{sql_where1})
				GROUP BY
					#{sql_group1}
				;
		EOT
		rows = self.connection.select_rows( sql )
		for row in self.connection.select_rows( sql )
			values = {}
			report.columns.each_index do |i|
				col = report.columns[i]
				value = col.format(row[i])
				values[col] = value
			end
			row = ActiveReporting::Report::Row.new( values )
			report.rows << row
		end
		report
	end
	
  def report_disposition_matrix
    srs = [] + self.stage_reviewers
    sr_ids = srs.collect(&:id)
    ds_ids = self.project.document_sources.collect(&:id)
    sql = [
      "SELECT", ( srs.collect { |sr| "dr#{sr.id}.disposition" } + [ "COUNT(*)" ]  ).join(", "),
      "FROM documents",
      sr_ids.collect { |srid| "LEFT JOIN document_reviews dr#{srid} on dr#{srid}.stage_reviewer_id = #{srid} and dr#{srid}.document_id = documents.id" }.join(" "),
      "WHERE document_source_id in (#{ds_ids.join(',')})",
      "AND (",
	sr_ids.collect { |srid| "dr#{srid}.id IS NOT NULL" }.join(" OR "),
      ")",
      "GROUP BY", sr_ids.collect { |srid| "dr#{srid}.disposition" }.join(", ")
    ].join(' ')
    rows = self.connection.select_rows( sql )
    agreement_report = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = Hash.new(0) } }
    disagreement_report = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = Hash.new(0) } }
    all_report = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = Hash.new(0) } }
    total = 0
    query_result = rows.collect { |row| Hash[ (srs + [ :count ]).zip( row ) ] }
    query_result.each do |h|
      c = h[:count].to_i
      total += h[:count].to_i
      srs.each do |sr|
        all_report[sr][ h[sr] ][ h.reject { |k,v| k == :count || k == sr }.values ] += c
      end
      srs.combination(2).each do |sr1,sr2|
        if h[sr1] == h[sr2]
          d = h[sr1]
          agreement_report[sr1][sr2][d] += c
          agreement_report[sr2][sr1][d] += c 
        else
          disagreement_report[sr1][sr2][ [h[sr1],h[sr2]] ] += c
          disagreement_report[sr2][sr1][ [h[sr2],h[sr1]] ] += c
        end
      end
    end
    { :total => total, :agreement => agreement_report, :disagreement => disagreement_report, :all => all_report }
  end
end
