class Scraper < ActiveRecord::Base

	has_many :pages
	has_many :parameters
	has_many :postings

	def exists?
		File.exists?(self.filename)
	end

	def filename
		File.join(Rails.root, 'app', 'scrapers', self.name.underscore + '.rb')
	end

	def instance
		self.name.constantize.new
	end

	def reset!
		self.pages.each do |page|
			page.reset_times!
		end
	end

	def force_scrape!
		self.reset!
		self.instance.queue_next_page_scrape
	end

end
