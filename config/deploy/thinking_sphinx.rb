
namespace :thinking_sphinx do

	desc "stop thinking_sphinx"
	task :stop, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:stop"
	end

	desc "start thinking_sphinx"
	task :start, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:start"
	end

	desc "index thinking_sphinx"
	task :index, :roles => :app do
		run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:index"
	end

end


before 'thinking_sphinx:start', 'thinking_sphinx:index'
before 'deploy', 'thinking_sphinx:stop'
before 'deploy:restart', 'thinking_sphinx:start'
