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
	
	def link_to_tree(record,display,url)
		return '' if record.nil?
		if display.is_a?(Proc)
			title = display.call(record)
		elsif display.is_a?(Symbol)
			title = record.send(display)
		else
			title = display
		end
		title = content_tag :span, title, :class => 'text'
		link_to_unless_current( title, url, :class => 'tree leaf') do
			content_tag :span, title, :class => 'tree leaf here'
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
							@achievement[:value] ||= "#{@achievement[:count]}/#{@achievement[:total]}"
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
		options = { :delimiter => ',', :empty_content => 'none', :connector => 'and' }.merge( options )
		parts = collection.collect { |x| capture(x,&block) }
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
		return w.length > 2 ? w[0..2].join(' ') + '...' : text
	end

	def personal_link_to( user, suffix =nil, url =nil)
		url ||= user_path(user)
		subject = if not user.is_a?(User)
			"#{user}"
		elsif user == current_user
			"You"
		elsif current_page?(url)
			user.nickname
		else
			user.full_name
		end
		link = content_tag :span, link_to_unless_current( subject, url ), :class => 'user'
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
		re = Regexp.new( "(" + keywords.sort { |a,b| b.length <=> a.length }.join("|") + ")", Regexp::IGNORECASE )
		return h(text).gsub( re, '<span class="keyword">\1</span>' )
	end
end
