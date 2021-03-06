# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def render_report( report, &block )
		thead_tr_tds = report.columns.collect { |col| content_tag :th, col.title, :class => col.is_group? ? 'group' : 'value' }
		thead_tr_html = content_tag :tr, thead_tr_tds.join("")
		thead_html = content_tag :thead, thead_tr_html
		
		tbody_trs = report.rows.collect do |row|
			tbody_tr_tds = report.columns.collect { |col| content_tag( col.is_group? ? :th : :td, row.value(col)) }
			content_tag :tr, tbody_tr_tds.join("")
		end
		tbody_html = content_tag :tbody, tbody_trs.join("\n")
		
		tfoot_tr_tds = report.columns.collect { |col| content_tag :th, col.summary_value }
		tfoot_tr_html = content_tag :tr, tfoot_tr_tds.join("")
		tfoot_html = content_tag :tfoot, tfoot_tr_html
		
		content_tag :table, [thead_html, tbody_html, tfoot_html].join("\n"), :class => 'report'
	end
	
	def link_to_task( title, url )
		task_html = content_tag(:span, "", :class => "overlay") + content_tag(:span, title, :class => "title")
		link_to_unless_current( task_html, url, :class => "task" ) do
			content_tag( :span, task_html, :class => "task" )
		end
	end
	
	def link_to_tree(record,display,url)
		return '' if record.nil?
		if display.is_a?(Proc)
			title = display.call(record)
		elsif display.is_a?(Symbol)
			title = record.send(display)
		else
			title = display
		end
		if url.is_a?(Proc)
			url = url.call(record)
		end
		category = content_tag :span, record.class.name.titleize, :class => 'category'
		title = content_tag :span, title, :class => 'text'
		link_to_unless_current( category + title, url, :class => 'tree leaf') do
			content_tag :span, category + title, :class => 'tree leaf here'
		end
	end
	
	def tree( options ={}, &block )
		treeBuilder = TreeBuilder.new(self)
		yield( treeBuilder )
		concat( treeBuilder.render, block.binding )
	end

	class TreeBuilder
		#object_name = ActionController::RecordIdentifier.singular_class_name(object)
		def initialize(view)
			@leaves = {}
			@root = TreeNode.new( view, @leaves )
		end
		def method_missing( methodId, *args )
			method_name = methodId.to_s
			self.add_mapping( method_name, *args )
			nil
		end
		def add_mapping( method_name, options ={} )
			@leaves[method_name.to_sym] = options
		end
		def node( *args, &block )
			@root.node( *args, &block )
		end
		def render
			@root.render
		end
		class TreeNode
			def initialize(view, leaves, path =[])
				@view = view
				@html = ""
				@leaves = leaves
				@path = path
			end
			def path_for_node
				method_name = @path.collect { |p| p.is_a?(String) ? p : p.class.name.underscore  }.join("_") + "_path"
				@view.send( method_name, *@path )
			end
			def node( object, options ={}, &block )
				if object.is_a?(Symbol) || object.is_a?(String)
					singular_object = @view.send(:eval, "@#{object.to_s}")
					plural_object = @view.send(:eval, "@#{object.to_s.pluralize}")
					plural_count = @view.send(:eval, "@#{object.to_s}_count")
					if singular_object
						self.node( singular_object, {}, &block )
					end
					if plural_object
						method_path_parts = @path.collect { |p| p.is_a?(String) ? p : p.class.name.underscore  }
						method_path_parts << object.to_s.pluralize
						method_name = method_path_parts.join("_") + "_path"
						url = @view.send( method_name, *@path )
						
						self.node( plural_object, { :category => object, :url => url, :count => plural_count }, &block )
					elsif ! @path.empty?
						if @path.last.respond_to?(object.to_s.pluralize)
							plural_object = @path.last.send(object.to_s.pluralize)
							method_name = @path.collect { |p| p.is_a?(String) ? p : p.class.name.underscore  }.join("_") + "_#{object.to_s.pluralize}_path"
							url = @view.send( method_name, *@path )
							self.node( plural_object, { :category => object, :url => url, :count => plural_object.size }, &block )
						end
					end
				elsif object.is_a?(Enumerable)
					if options[:category]
						category = options[:category]
						url = options[:url]
						count = options[:count] || object.size
						title = @view.pluralize( count, category.to_s.titleize )
						title = @view.content_tag( :span, title, :class => 'category' )
						@html << @view.link_to_unless_current( title, url, :class => 'tree leaf' ) do
							@view.content_tag( :span, title, :class => 'tree leaf here' )
						end
					elsif object.size < 5
						object.each { |obj| self.node( obj, {}, &block ) }
					else
						self.node( object[0..2], {}, &block )
						# add note about more...
					end
				else
					nodeBuilder = TreeNode.new(@view, @leaves, @path + [ object ])
					defn = @leaves[object.class.name.underscore.to_sym]
					if defn
						url = defn[:url] || nodeBuilder.path_for_node
						@html << @view.link_to_tree( object, defn[:show], url )
					end
					if block_given?
						yield(nodeBuilder)
						@html << nodeBuilder.render
					end
				end
			end
			def render
				@html
			end
		end
	
	
	end

	class FlowSequence
		def initialize()
			@steps = { }
		end
		def step( title, options ={}, &block )
			flowstep = FlowStep.new( title, options )
			flowstep.part_of_sequence self
			yield(flowstep) if block_given?
			@steps[ flowstep.title ] = flowstep
			flowstep
		end
		def find_step( title )
			@steps[ title ]
		end
	end
	
	class FlowStep
		include ActionView::Helpers::TagHelper
		include ActionView::Helpers::TextHelper
		include ActionView::Helpers::CaptureHelper
		include ActionView::Helpers::NumberHelper
		
		def initialize( title =nil, options =nil )
			@title = title
			@complete = nil
			@achievement = nil
			@final = false
			@url = nil
			unless options.nil?
				for key in [ :title, :status, :complete, :incomplete, :complete_if, :complete_unless, :incomplete_if, :incomplete_unless, :achievement, :final, :url ]
					self.send( key, options[key] ) if options.has_key?(key)
				end
			end
		end
		def part_of_sequence( seq )
			@sequence = seq
		end
		def title( title =nil )
			@title = title unless title.nil?
			@title
		end
		def url( url )
			@url = url
		end
		def partial_if(condition,amount)
			partial(amount) if condition
		end
		def complete_if(condition)
			self.complete if condition
		end
		def complete_unless(condition)
			self.complete unless condition
		end
		def incomplete_if(condition)
			self.incomplete if condition
		end
		def incomplete_unless(condition)
			self.incomplete unless condition
		end
		def partial(amount)
			if amount >= 1.0
				self.complete
			elsif amount <= 0.0
				self.incomplete
			else
				self.status(amount.to_f)
			end
		end
		def complete
			self.status(true)
		end
		def incomplete
			self.status(false)	
		end
		def status(status =nil)
			@complete = status unless status.nil?
			@complete
		end
		def final( f =true )
			@final = f
		end
		def achievement( title_or_options =nil, options =nil)
			options = title_or_options if title_or_options.is_a?(Hash)
			@achievement = { :title => title_or_options || options[:title] }
			@achievement.merge! options
			if @achievement.has_key?(:count)
				if @achievement.has_key?(:total) 
					if @achievement[:total] > 0
						frac = @achievement[:count].to_f / @achievement[:total]
						self.partial frac
						if frac < 0.10 || @achievement[:count] < 20
							@achievement[:value] ||= "#{number_with_delimiter @achievement[:count]}<span class='fraction'>of</span>#{number_with_delimiter @achievement[:total]}"
						else
							@achievement[:value] ||= (100 * frac).to_i.to_s + '<span class="units">%</span>'
						end
					end
				else
					self.complete_if @achievement[:count] > 0
					self.incomplete_if @achievement[:count] == 0
					@achievement[:value] ||= number_with_delimiter(@achievement[:count])
				end
			elsif @achievement[:value].is_a?(Numeric)
				self.complete_if @achievement[:value] > 0
				self.incomplete_if @achievement[:value] == 0
			elsif @achievement.has_key?(:value)
				self.incomplete_if @achievement[:value].nil?
			end
		end
		def to_s
			tag_classes = [ 'flowstep' ]
			tag_classes << 'complete' if @complete == true
			tag_classes << 'incomplete' if @complete == false
			tag_classes << 'partial' if @complete.is_a?(Numeric)
			tag_classes << 'none' if @complete.nil?
			detail_html = content_tag('div', '', :class => 'icon')
			if @achievement && !@achievement[:value].nil?
				ach_html = content_tag( 'div', @achievement[:value], :class => 'value')
				ach_html += content_tag( 'div', @achievement[:title], :class => 'subtitle')
				detail_html += content_tag( 'div', ach_html, :class => 'achievement' )
			end
			detail_html += @title
			if @url && ( @achievement.nil? || !@achievement[:value].nil? )
				fs_html = content_tag 'a', detail_html, :class => tag_classes.join(' '), :href => @url
			else
				fs_html = content_tag 'div', detail_html, :class => tag_classes.join(' ')
			end
			unless @final
				fs_html += content_tag 'div', "", :class => 'flowcontinue'
			end
			return fs_html
		end
		
		def given( title, status, &block )
			flowstep = @sequence.nil? || @sequence.find_step(title)
			if block_given? && ( flowstep.nil? || flowstep.complete == status )
				yield(self)
			end
		end
	end
	def flow_sequence
		FlowSequence.new
	end	
	def flow_step( title, options ={}, &block )
		flowstep = FlowStep.new( title, options )
		yield(flowstep) if block_given?
		flowstep
	end
		
	def box(style,&block)
		return unless block_given?
		contents = capture(&block)
		concat( "<table class='box #{style}'><tbody><tr class='top'><td class='left'/><td class='middle'/><td class='right'/></tr><tr class='middle'><td class='left'/><td class='middle'>#{contents}<td class='right'/></tr><tr class='bottom'><td class='left'/><td class='middle'/><td class='right'/></tr></tbody></table>", block.binding )
	end
	
	def delimited_list(collection, options ={}, &block)
		return unless block_given?
		options = { :delimiter => ',', :empty_content => 'none', :connector => 'and', :trim => true }.merge( options )
		parts = collection.collect { |x| capture(x,&block) }
		if options[:trim]
			parts.each { |x| x.strip! }
			options[:delimiter] += ' '
		end
		result = case parts.length
			when 0
				content_tag :span, options[:empty_content], :class => :missing
			when 1
				parts[0]
			when 2
				parts.join(options[:connector] && " #{options[:connector]} ")
			else
				parts[-1].insert(0,"#{options[:connector]} ") if options[:connector]
				parts.join(options[:delimiter] || '' )
		end
		concat( result, block.binding )
	end
	
	def abbreviate(text, words =3)
		w = text.split(' ')
		return w.length > words ? w[0..words].join(' ') + '...' : text
	end

	def personal_link_to( user, options_or_suffix =nil, options_or_url =nil, options =nil )
		if options_or_suffix.is_a?(Hash)
			suffix = nil
			url = nil
			options = options_or_suffix
		elsif options_or_url.is_a?(Hash)
			suffix = options_or_suffix
			url = nil
			options = options_or_url
		else
			suffix = options_or_suffix
			url = options_or_url
			options ||= {}
		end
		url ||= user_path(user)
		subject = if not user.is_a?(User)
			"#{user}"
		elsif user == current_user
			"You"
		elsif options[:display].is_a?(Symbol)
			user.send( options[:display] )
		elsif options[:display]
			options[:display]
		elsif current_page?(url)
			user.nickname
		else
			user.full_name
		end
		link = content_tag :span, link_to_unless_current( subject, url, options ), :class => 'user'
		return link unless suffix && !suffix.empty?
		first_person = "#{suffix}"
		second_person = "#{suffix}"
		delimiter = ' '
		case suffix
			when /^'s/
				if subject == 'You'
					subject = 'Your'
					first_person.sub!( /^'s/, '' )
					second_person.sub!( /'s/, '' )
				end
				delimiter = ''
			when /^(is|are)/
				first_person.sub!( /^is/, 'are' )
				second_person.sub!( /^are/, 'is' )
			when /^(has|have)/
				first_person.sub!( /^has/, 'have' )
				second_person.sub!( /^have/, 'has' )
		end
		verb = user == current_user ? first_person : second_person
		link = content_tag :span, link_to_unless_current( subject, url ), :class => 'user'
		return [link,verb].join(delimiter)
	end
	
	def hilite_keywords( text, keywords )
		return h(text) if keywords.blank?
		keywords = keywords.scan(/([^\s,;"']+)|'([^']*)'|"([^"]*)"/).collect{ |x| x.reject(&:nil?).first } unless keywords.is_a?(Array)
		re = Regexp.new( "(" + keywords.sort { |a,b| b.length <=> a.length }.join("|") + ")", Regexp::IGNORECASE )
		title = "Keywords: " + keywords.join(', ')
		return h(text).gsub( re, "<span class=\"keyword\" title=\"#{title}\">\\1</span>" )
	end
end
