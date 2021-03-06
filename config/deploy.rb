PRODUCTION_SERVERS = %w[10.0.0.1 10.0.0.2]
VM_AHN_SERVERS = '10.0.1.12'

TESTING_SERVER =%w[10.0.0.1]

set :application, "pbx-gui"

# Git/Github setup
set :scm, :git
set :repository,  "git@github.com:woever/blah.git"

set :project_deploy_to_root, "/usr/local/engineyard"

set :deploy_to, "#{project_deploy_to_root}/#{application}"

set :main_server, "192.168.2.3"

# role :db,  "your db-server here", :primary => true

# before 'deploy', 'commit_remote_database_changes'
after 'deploy', 'delete_development_actions'
after 'deploy', 'restart_messaging_system'
after 'deploy', 'restart_adhearsion'

task :commit_remote_database_changes do
  run "cd #{deploy_to}/current && git commit -m 'Capistrano: Committing web app database changes' --only db/development.sqlite3; git push"
  exec "git pull"
end

task :delete_development_actions do
  run %% sqlite3 #{deploy_to}/current/db/development.sqlite3 'delete from actions'%
end

task :restart_messaging_system do
  run '/etc/init.d/ahn_queue_fetcher restart'
end

task :restart_adhearsion do
  run '/etc/init.d/adhearsion restart'
end

task :production do
  set :user, "root" # Must change to 'deploy'!
  set :use_sudo, false
  role :app, *PRODUCTION_SERVERS
  role :web, *PRODUCTION_SERVERS
end

task :testing do
  set :user, "root" # Must change to 'deploy'!
  set :use_sudo, false
  role :app, *TESTING_SERVER
  role :web, *TESTING_SERVER
end

task :vm do
  set :user, 'deploy'
  role :app, *VM_AHN_SERVERS
  role :web, *VM_AHN_SERVERS
end

namespace :deploy do
  task :start do
    run 'thin start -C /etc/thin/pbx_gui.yml'
  end
  
  task :stop do
    run 'thin stop -C /etc/thin/pbx_gui.yml'
  end
  
  task :restart do
    stop
    start
  end
end