module ActiveReporting

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def add_report
			include ActiveReporting::InstanceMethods
			extend ActiveReporting::SingletonMethods
		end
	end
	
	module SingletonMethods
		# add class methods here
		def define_report( name, options = {} )
			# add the report spec to the class's list of supported reports
		end
	end
	
	module InstanceMethods
		# add instance methods here
		def report( name )
			spec = {} # look up spec by name from those defined by define_report(...)
			return ActiveReporting::Report.new( {} ) 
		end
	end
	

end
