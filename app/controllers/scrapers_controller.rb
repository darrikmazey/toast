class ScrapersController < ApplicationController
	
	def index
		@scrapers = Scraper.all
	end

end
