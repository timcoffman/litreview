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
	end
	
	module InstanceMethods
		# add instance methods here
	end
	
	def report( spec ={} )
		return ActiveReporting::Report.new( spec ) 
	end

end
