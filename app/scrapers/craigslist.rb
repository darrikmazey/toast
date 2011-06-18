
class Craigslist
	
	def initialize
	end

	def home_page_url
		"http://www.craigslist.org/"
	end

	def find_pages
		system("echo 'finding pages for #{self.class.to_s}' >> /tmp/#{self.class.to_s.underscore}")
		home = Page.new(:url => self.home_page_url)
		doc = home.doc
		sites = doc.css('a').map {|link| link.attributes["href"].value }.select { |href| href =~ /^http:\/\/[^.]+\.craigslist.org\/?$/ }.delete_if { |href| href =~ /\/blog\./ }
		scraper = Scraper.find_by_name(self.class.to_s)
		sites.each do |href|
			url = href
			url = "#{url}/" unless url =~ /\/$/
			if Page.find_by_url(url).nil?
				p = Page.new
				p.url = url
				p.scraper = scraper
				if p.save
					self.delay.find_other_pages(p.id)
				end
			end
		end
		wait_if_necessary
		self.delay(:run_at => DateTime.now + 5.minutes).queue_next_page_scrape
	end

	def find_other_pages(page_id)
		page = Page.find(page_id)
		if page
			system("echo 'finding other pages for #{self.class.to_s} : #{page.url}' >> /tmp/#{self.class.to_s.underscore}")
			doc = page.doc
			sites = doc.css('a').map {|link| link.attributes["href"].value }.select { |href| href =~ /^http:\/\/[^.]+\.craigslist.org\/?$/ }.delete_if { |href| href =~ /\/blog\./ }
			scraper = page.scraper
			sites.each do |href|
				url = href
				url = "#{url}/" unless url =~ /\/$/
				if Page.find_by_url(url).nil?
					p = Page.new
					p.url = url
					p.scraper = scraper
					if p.save
						self.delay.find_other_pages(p.id)
					end
				end
			end
			wait_if_necessary
		end
	end

	def reload_postings
		scraper = Scraper.find_by_name(self.class.to_s)
		scraper.postings.unloaded.each do |post|
			self.delay.load_posting(post.id)
		end
		self.delay(:run_at => (DateTime.now + 8.hours)).reload_postings
	end

	def load_posting(posting_id)
		post = Posting.find(posting_id)
		if post
			doc = post.doc

			# find posting date
			date = doc.css('body').children.select { |c| c.class == Nokogiri::XML::Text && c.content =~ /Date/ }.first.content rescue ''
			if date =~ /Date:(.*)/
				post.posted_at = DateTime.parse($1.strip!)
			end

			# find reply-to email
			mailto = doc.css('a').map { |link| link.attributes["href"].value rescue nil }.select { |href| href =~ /mailto:/ }.first
			if mailto =~ /mailto:(.*)/
				post.email = $1
			end

			post.long_content = doc.css('#userbody').to_html
			post.loaded = true
			post.save
		end
		wait_if_necessary
	end

	def scrape_page(page_id)
		p = Page.find(page_id)
		scraper = Scraper.find_by_name(self.class.to_s)
		categories = scraper.parameters.find_by_name("categories").value.split(/,/)
		f = File.open("/tmp/craigslist.jobs", 'w')
		if p
			p.start_scrape!
			categories.each do |cat|
				page = Page.new
				page.url = "#{p.url}#{cat}/"
				doc = page.doc
				doc.css('p a').each do |link|
					url = link.attributes["href"].value
					if Posting.find_by_url(url).nil? and url =~ /^http/
						post = Posting.new
						post.page = p
						post.scraper = scraper
						post.url = url
						post.brief_content = link.content
						post.loaded = false
						post.save
						self.delay.load_posting(post.id)
					end
				end
			end
			p.end_scrape!
		end
		f.close
		wait_if_necessary
		queue_next_page_scrape
	end

	def queue_next_page_scrape
		scraper = Scraper.find_by_name(self.class.to_s)
		interval = scraper.parameters.find_by_name("interval").value.to_i
		p = scraper.pages.order('scrape_ended_at asc, id asc').first
		if p
			next_run = [DateTime.now, (p.scrape_ended_at + interval.seconds rescue DateTime.now)].max
			self.delay(:run_at => next_run).scrape_page(p.id)
		else
			self.delay(:run_at => DateTime.now + 1.hour).queue_next_page_scrape
		end
	end

	def wait_if_necessary
		del = Scraper.find_by_name(self.class.to_s).parameters.find_by_name("action_delay").value.to_i rescue 0
		if del > 0 and del <= 30
			sleep(del)
		end
	end

end
