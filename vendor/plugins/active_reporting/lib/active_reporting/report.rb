module ActiveReporting
	class Report
		def initialize( options ={} )
			@columns = [ ]
			@rows = [ ]
			@description = options[:dsecription] || "A Report"
		end
		def description()
			@description
		end
		def columns
			@columns
		end
		def rows
			@rows
		end

		class Column
			def initialize( options ={})
				@title = options[:title] || "Column"
				@formatter = options[:formatter] || Proc.new { |v| v.to_s }
			end
			def title
				@title
			end
			def summary_value
				""
			end
			def format( v )
				@formatter.call(v)
			end
			def is_group?
				false
			end
		end
		class Row
			def initialize( values )
				@values = values
			end
			def value( col )
				@values[col]
			end
		end
	end
end
