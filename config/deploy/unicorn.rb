
namespace :unicorn do
	desc "restart unicorn"
	task :restart, :roles => :app do
		run "cd #{deploy_to}/current; [ -f tmp/pids/unicorn.pid ] && sudo kill -USR2 `cat tmp/pids/unicord.pid` || sudo /usr/bin/unicorn_rails -c config/unicorn-#{application}.rb -E production -D"
	end

	desc "autostart site"
	task :autostart, :roles => :app do
		run "cd /etc/unicorn/sites && sudo ln -s #{deploy_to}/current #{application}"
	end

	desc "no autostart"
	task :no_autostart, :roles => :app do
		run "sudo rm -f /etc/unicorn/sites/#{application}"
	end

	desc "make unicorn directories"
	task :make_unicorn_dirs, :roles => :app do
		run "cd #{deploy_to} && mkdir -p shared/sockets shared/pids"
	end

	desc "update unicorn symlinks"
	task :update_unicorn_symlinks, :roles => :app do
		run "cd #{deploy_to}/current/tmp/sockets && ln -s #{deploy_to}/shared/sockets/#{application}.sock unicorn.sock"
		run "cd #{deploy_to}/current/tmp/pids && ln -s #{deploy_to}/shared/pids/#{application}.pid unicorn.pid"
		run "cd #{deploy_to}/current/tmp/pids && ln -s #{deploy_to}/shared/pids/#{application}.pid.oldbin unicorn.pid.oldbin"
	end

	desc "symlink sockets dir"
	task :symlink_sockets_dir, :roles => :app do
		run "cd #{release_path}/tmp && ln -s #{deploy_to}/shared/sockets"
	end
end

after 'deploy:copy_code_to_release', 'unicorn:make_unicorn_dirs'
after 'deploy:symlink_pids_dir', 'unicorn:symlink_sockets_dir'
after 'unicorn:symlink_sockets_dir', 'unicorn:update_unicorn_symlinks'
