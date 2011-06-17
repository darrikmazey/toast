class PostingsController < ApplicationController
	before_filter :load_scraper, :only => [:index]
	before_filter :load_page, :only => [:index]

	def index
		if @page
			@total_postings = @page.postings.order('posted_at desc').count
			@postings = @page.postings.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
		elsif @scraper
			@total_postings = @scraper.postings.order('posted_at desc').count
			@postings = @scraper.postings.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
		else
			@total_postings = Posting.order('posted_at desc').count
			@postings = Posting.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
		end
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

	def load_page
		@page = Page.find(params[:page_id]) rescue nil
	end

end
