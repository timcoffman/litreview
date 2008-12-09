

module ActionView
	module Helpers #:nodoc:
		module AssetTagHelper

			def dtd_path(source)
				compute_public_path(source, 'dtds', 'dtd')
			end
			def schema_path(source)
				compute_public_path(source, 'schemas', 'dtd')
			end
		
		end
	end
end