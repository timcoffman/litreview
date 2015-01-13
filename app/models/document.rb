class Document < ActiveRecord::Base
	belongs_to :document_source
	has_many :document_reviews, :dependent => :delete_all
	has_many :stage_reviewers, :through => :document_reviews
	has_many :duplicate_documents, :class_name => 'Document', :foreign_key => :duplicate_of_document_id, :dependent => :nullify
	belongs_to :duplicate_of_document, :class_name => 'Document', :foreign_key => :duplicate_of_document_id
	has_many :document_tags, :dependent => :delete_all
	has_many :tags, :through => :document_tags
	
	before_save :truncate_values
	
	def truncate_values
		[ :pub_ident, :title, :authors, :journal, :when_published, :abstract ].each do |g|
			s = (g.to_s + "=").to_sym
			v = self.send(g)
			limit = Document.columns_hash[g.to_s].limit
			if v && limit && v.length > limit
				v = v[0..(limit-5)] + "..."
				self.send(s,v) 
			elsif v && v.empty?
				self.send(s,nil)
			end
		end
	end
	
	
end
