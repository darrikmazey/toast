class PostingsController < ApplicationController
	before_filter :load_scraper, :only => [:index, :all_new]
	before_filter :load_page, :only => [:index, :all_new]

	def index
		if @page
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:ignored => 0, :page_id => @page.id}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = @page.postings.not_ignored.order('posted_at desc').count
				@postings = @page.postings.not_ignored.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		elsif @scraper
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:ignored => 0, :scraper_id => @scraper.id}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = @scraper.postings.not_ignored.order('posted_at desc').count
				@postings = @scraper.postings.not_ignored.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		else
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:ignored => 0}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = Posting.not_ignored.order('posted_at desc').count
				@postings = Posting.not_ignored.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		end
	end

	def all_new
		if @page
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:new => 1, :ignored => 0, :page_id => @page.id}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = @page.postings.are_new.order('posted_at desc').count
				@postings = @page.postings.are_new.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		elsif @scraper
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:new => 1, :ignored => 0, :scraper_id => @scraper.id}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = @scraper.postings.are_new.order('posted_at desc').count
				@postings = @scraper.postings.are_new.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		else
			if params[:search]
				@postings = Posting.search(params[:search], :with => {:new => 1, :ignored => 0}, :order => :posted_at, :sort_mode => :desc, :match_mode => :boolean, :per_page => 25, :page => params[:page])
				@total_postings = @postings.total_entries
			else
				@total_postings = Posting.are_new.order('posted_at desc').count
				@postings = Posting.are_new.order('posted_at desc').paginate(:per_page => 25, :page => params[:page])
			end
		end
		render :action => :index
	end

	def ignore
		@posting = Posting.find(params[:id])
		@posting.ignored = true
		@posting.new = false
		@posting.save
		redirect_to postings_url
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

	def load_page
		@page = Page.find(params[:page_id]) rescue nil
	end

end
