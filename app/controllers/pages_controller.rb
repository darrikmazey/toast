class PagesController < ApplicationController

	before_filter :load_scraper, :only => [:index]

	def index
		if params[:search]
			@pages = Page.search(params[:search], :star => :true, :order => :scrape_ended_at, :sort_mode => :asc, :per_page => 25, :page => params[:page])
		elsif !@scraper.nil?
			@pages = @scraper.pages.order('scrape_ended_at asc, id asc').paginate(:per_page => 25, :page => params[:page])
		else
			@pages = Page.order('scrape_ended_at asc, id asc').paginate(:per_page => 25, :page => params[:page])
		end
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

end
