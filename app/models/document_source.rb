require 'ftools'
require 'amatch'

class DocumentSource < ActiveRecord::Base
	belongs_to :project
	has_many :documents, :dependent => :delete_all
	
	def import_file_location
		"#{APPLICATION_DATA_LOCATION}/document_source/#{self.id}"
	end
	
	def import_file_path
		"#{self.import_file_location}/import.txt"
	end
	
	def has_import_file?
		File.exists?( self.import_file_path )
	end
	
	def when_import_file_uploaded
		return nil unless self.has_import_file?
		File.mtime( self.import_file_path )
	end
	
	def store_import_file(contents)
		File.makedirs( self.import_file_location )
		File.open( self.import_file_path, "w" ) do |file|
			file.write( contents.read ) if contents && contents.respond_to?(:read)
		end
	end
	
	def retrieve_import_file
		return nil unless self.has_import_file?
		File.open( self.import_file_path, "r" ) do |file|
			file.read
		end
	end
	def import_file_preview
		return "" unless self.has_import_file?
		preview = ""
		File.open( self.import_file_path, "r" ) do |file|
			(1..5).each { line = file.gets ; break unless line ; preview += line.slice(0,79) }
		end
		return preview
	end
	
	def import_file_column_names
		return []  unless self.has_import_file?
		header_line = nil
		File.open( self.import_file_path, "r" ) do |file|
			header_line = file.gets
		end
		return []  unless header_line
		return header_line.rstrip.split("\t") ;
	end
	
	def self.importable_attributes
		return {
			'Title' => :title,
			'Authors' => :authors,
			'Identifier' => :pub_ident,
			'When Published' => :when_published,
			'Abstract' => :abstract,
			'Journal' => :journal
			}
	end
	
	def self.import_column_name_best_matches( column_names )
		best_matches = {}
		column_names.each do |column_name|
			best_match = importable_attributes.keys.max { |a,b| column_name.longest_subsequence_similar(a) <=> column_name.longest_subsequence_similar(b) }
			best_matches[column_name] = best_match # should select from self.importable_attributes
		end
		return best_matches
	end
	
	def import( column_mapping, action = :merge, dry_run =nil )
		# do the importing here
		return { :status => :failed, :error => 'missing import file' } unless self.has_import_file?
		result = { :status => nil, :documents => [ ], :duplicates => [ ] } 
		File.open( self.import_file_path, "r" ) do |file|
			header_line = file.gets
			return { :status => :failed, :error => 'missing header line' } unless header_line
			self.documents.clear unless dry_run
			header_line.rstrip!
			column_names = header_line.split("\t")
			file.each do |data_line|
				details = { }
				fields = data_line.split("\t")
				column_names.each do |column_name|
					field_value = fields.shift
					attribute_name = column_mapping[column_name]
					details[attribute_name] = field_value unless attribute_name.nil? || attribute_name.empty?
				end
				original_document = self.documents.find_by_pub_ident( details[:pub_ident] )
				if not original_document.nil?
					result[:duplicates] << self.documents.build( details.merge( :duplicate_of_document => original_document ) )
				elsif dry_run
					result[:documents] << self.documents.build( details )
				else
					result[:documents] << self.documents.create( details )
				end
			end
			result[:status] = :success
		end
		return result ;
	end
end
