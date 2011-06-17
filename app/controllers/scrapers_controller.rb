class ScrapersController < ApplicationController
	
	def index
		@scrapers = Scraper.all
	end

	def find_pages
		@scraper = Scraper.find(params[:id])
		@scraper.instance.delay.find_pages
		redirect_to scrapers_url
	end

end
