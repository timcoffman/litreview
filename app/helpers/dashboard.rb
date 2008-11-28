class Dashboard
	def initialize
		@headsup_map = Hash.new { |h,k| h[k] = HeadsUp.new(k) ; @headsup_list << h[k] ; h[k]  }
		@headsup_list = Array.new
	end
	
	def headsup( name )
		# comment
		return @headsup_map[name]
	end
	
	def all
		@headsup_list
	end
	
	class HeadsUp
		def initialize(title)
			@title = title
			@items = Array.new
		end
		def title
			return @title
		end
		def items
			return @items
		end
	end
end
