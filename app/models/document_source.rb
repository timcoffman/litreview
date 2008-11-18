require 'ftools'

class DocumentSource < ActiveRecord::Base
	belongs_to :project
	has_many :documents
	
	def import_file_location
		"#{APPLICATION_DATA_LOCATION}/document_source"
	end
	
	def import_file_path
		"#{self.import_file_location}/#{self.identifier}.txt"
	end
	
	def has_import_file?
		File.exists?( self.import_file_path )
	end
	
	def when_import_file_uploaded
		return nil unless self.has_import_file?
		File.mtime( self.import_file_path )
	end
	
	def import_file=(contents)
		File.makedirs( self.import_file_location )
		File.open( self.import_file_path, "w" ) do |file|
			file.write( contents.read )
		end
	end
	
	def import_file
		File.open( self.import_file_path, "r" ) do |file|
			file.read
		end
	end
end
