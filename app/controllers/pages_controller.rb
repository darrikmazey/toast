class PagesController < ApplicationController

	before_filter :load_scraper, :only => [:index]

	def index
		if !@scraper.nil?
			@pages = @scraper.pages
		else
			@pages = Page.all
		end
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

end
