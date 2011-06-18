class Posting < ActiveRecord::Base
  belongs_to :scraper
  belongs_to :page

	scope :unloaded, { :conditions => { :loaded => false } }
	scope :are_loaded, { :conditions => { :loaded => true } }
	scope :are_new, { :conditions => { :new => true } }
	scope :not_ignored, { :conditions =>  { :ignored => false } }

	define_index do
		indexes :brief_content
		indexes :long_content

		has :posted_at
		has :ignored
		has :scraper_id
		has :page_id
		has :new
	end

	def fetch
		@doc = Nokogiri::HTML(open(self.url)) unless @doc
	end

	def doc
		self.fetch
		@doc
	end

	def loaded!
		self.loaded = true
		self.save
	end

	def formatted_posted_at
		begin
			if self.posted_at.localtime.to_date == Date.today
				"Today"
			else
				days = (Date.today - self.posted_at.localtime.to_date).to_i
				if days == 1
					"#{days} day ago"
				elsif days < 30
					"#{days} days ago"
				else
					months = days/30
					if months == 1
						"#{months} month ago"
					else
						"#{days/30} months ago"
					end
				end
			end
		rescue
			"unknown"
		end
	end
end
