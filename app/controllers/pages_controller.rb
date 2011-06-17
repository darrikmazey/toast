class PagesController < ApplicationController

	before_filter :load_scraper, :only => [:index]

	def index
		if !@scraper.nil?
			@pages = @scraper.pages.order('scrape_ended_at asc, id asc')
		else
			@pages = Page.all
		end
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

end
