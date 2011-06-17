require 'open-uri'

class Page < ActiveRecord::Base
  belongs_to :scraper
	has_many :postings

	before_create :set_found_at

	def fetch
		@doc = Nokogiri::HTML(open(self.url)) unless @doc
	end

	def doc
		self.fetch
		@doc
	end

	def start_scrape!
		self.scrape_started_at = DateTime.now
		self.scrape_ended_at = nil
		self.save
	end

	def end_scrape!
		self.scrape_ended_at = DateTime.now
		self.save
	end

	def reset_times!
		self.scrape_started_at = nil
		self.scrape_ended_at = nil
		self.save
	end

	private

	def set_found_at
		self.found_at = DateTime.now
	end

end
