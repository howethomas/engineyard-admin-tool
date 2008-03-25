PRODUCTION_SERVERS = %w[65.74.174.200 65.74.174.199]
VM_AHN_SERVERS = '10.0.1.194'

set :application, "pbx-gui"

# Git/Github setup
set :scm, :git
set :repository,  "git@github.com:jicksta/engineyard-admin-tool.git"

set :project_deploy_to_root, "/usr/local/engineyard"

set :deploy_to, "#{project_deploy_to_root}/#{application}"

set :main_server, "192.168.2.3"

# role :db,  "your db-server here", :primary => true

task :production do
  set :user, "root" # Must change to 'deploy'!
  set :use_sudo, false
  role :app, *PRODUCTION_SERVERS
  role :web, *PRODUCTION_SERVERS
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