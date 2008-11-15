module ActiveReporting
	class Report
		def initialize( spec =nil )
			spec ||= {} 
			@domain = [ 'name', 'x', 'y', 'z' ]
			@series = [ [ 'abc', 1, 2, 3 ], [ 'def', 4, 5, 6 ] ]
		end
		def description()
			"a report"
		end
		def domain()
			return @domain
		end
		def series()
			return @series
		end
	end
end
