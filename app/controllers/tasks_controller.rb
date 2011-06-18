class TasksController < ApplicationController

	def index
		@tasks = Delayed::Job.order('run_at asc').paginate(:per_page => 25, :page => params[:page])
	end

	def destroy
		@task = Delayed::Job.find(params[:id])
		@task.destroy
		redirect_to tasks_url
	end
end
