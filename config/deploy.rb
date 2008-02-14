set :application, "pbx-gui"
set :user, "jicksta" # Must change to 'deploy'!
set :use_sudo, false

# Git/Github setup
set :scm, :git
set :repository,  "git@github.com:jicksta/engineyard-admin-tool.git"

set :project_deploy_to_root, "/usr/local/engineyard"

set :deploy_to, "#{project_deploy_to_root}/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :main_server, "10.0.1.195"

role :app, main_server
role :web, main_server
# role :db,  "your db-server here", :primary => true