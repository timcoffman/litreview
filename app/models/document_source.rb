require 'ftools'
require 'amatch'

class DocumentSource < ActiveRecord::Base
	belongs_to :project
	has_many :documents, :dependent => :destroy
  has_many :import_mappings, :dependent => :delete_all
	
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
	
	def store_import_file(contents, format_conversion =nil )
		File.makedirs( self.import_file_location )
		File.open( self.import_file_path, "w" ) do |file|
			file.write( contents.read ) if contents && contents.respond_to?(:read)
		end
		if format_conversion
			system( File.expand_path( '../../script/citations2table.pl', __FILE__), format_conversion, self.import_file_path )
			tab_path = self.import_file_path.sub( /\.[^.]+$/, '.tab' )
			raise "Faile to convert \"#{format_conversion}\"-formatted file" unless File.exists? tab_path
			File.rename tab_path, self.import_file_path
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
		File.open( self.import_file_path, "r" ) do |file|
			header_line = file.gets
      header_line = file.gets while header_line =~ /^\s*$/
  		return []  unless header_line
      if header_line =~ /^([A-Z]+)\s*[-]\s+\S+/
        column_names = Set.new [ $1 ]
        header_line = file.gets
        while header_line =~ /\S/
          if header_line =~ /^([A-Z]+)\s*[-]\s+\S+/
            column_names << $1
          end
          header_line = file.gets
        end
        return column_names
      elsif header_line =~ /^[^\t]+(\t[^\t]*)*$/
  		  return header_line.rstrip.split("\t") ;
  		else
        return []  
      end
    end  
	end
	
	def self.importable_attributes
		return {
			'Title' => :title,
			'Authors' => :authors,
			'Identifier' => :pub_ident,
      'When Published' => :when_published,
			'Abstract' => :abstract,
      'Journal' => :journal,
			}
	end
	
	def import_column_name_best_matches( column_names )
    if self.import_mappings.empty? 
  		best_matches = {}
  		column_names.each do |column_name|
  			best_match = DocumentSource.importable_attributes.keys.max { |a,b| column_name.longest_subsequence_similar(a) <=> column_name.longest_subsequence_similar(b) }
  			best_matches[column_name] = best_match if column_name.longest_subsequence_similar(best_match) > 0.1
  		end
  		return best_matches
    else
      reverse_importable_attributes = DocumentSource.importable_attributes.invert
      return column_names.inject( Hash.new ) do |best_matches,column_name|
        if import_mapping =   self.import_mappings.find( :first, :conditions => { :column_heading => column_name } )
          best_matches[column_name] = reverse_importable_attributes[import_mapping.document_attribute.to_sym]
        end
        best_matches
      end
    end
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
      
        duplicate_of_documents = self.project.documents.find( :all, :order => 'created_at ASC', :conditions => [
          'duplicate_of_document_id IS NULL AND (pub_ident = :pub_ident OR title = :title OR ( abstract IS NOT NULL AND abstract = :abstract ) )',
          {
            :pub_ident => details['pub_ident'],
            :title => details['title'],
            :abstract => details['abstract'],
          }
        ] )
        
        details[:duplicate_of_document] = duplicate_of_documents.first
        
				if dry_run
					result[:documents] << self.documents.build( details )
				else
					result[:documents] << self.documents.create( details )
				end
			end
			result[:status] = :success
	  end
  
    self.import_mappings.clear
    column_mapping.reject { |k,v| v.blank? }.each do |column_name,document_attribute|
      self.import_mappings.create(:column_heading => column_name, :document_attribute => document_attribute )
    end
  
		return result ;
	end
end
