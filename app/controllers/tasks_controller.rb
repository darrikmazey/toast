class TasksController < ApplicationController

	def index
		@tasks = Delayed::Job.order('run_at asc').paginate(:per_page => 25, :page => params[:page])
	end

end
