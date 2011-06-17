class ParametersController < ApplicationController

	before_filter :load_scraper, :only => [:index]

	def index
		@parameters = @scraper.parameters
	end

	private

	def load_scraper
		@scraper = Scraper.find(params[:scraper_id]) rescue nil
	end

end
