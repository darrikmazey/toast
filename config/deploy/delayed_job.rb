
namespace :delayed_job do

	desc "stop delayed_job"
	task :stop, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec script/delayed_job stop"
	end

	desc "start delayed_job"
	task :start, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec script/delayed_job start"
	end

	desc "restart delayed_job"
	task :restart, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec script/delayed_job restart"
	end

end

before 'deploy', 'delayed_job:stop'
after 'deploy', 'delayed_job:start'
