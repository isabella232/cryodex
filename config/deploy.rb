require 'rvm/capistrano'

# Application configuration.
set :application, 'joinsyme'

# Server login configuration.
set :user, 'web'
set :port, 1023
set :domain, '198.27.65.229'
set :use_sudo, false
ssh_options[:keys] = [File.join(ENV['HOME'], '.ssh', 'syme-web')]

set :scm, :git
set :scm_verbose, true
set :repository, 'git@github.com:louismullie/syme-showcase.git'
set :branch, 'develop'

# Deployment configuration.
set :deploy_to, '/var/www/getsyme.com'
set :deploy_via, :remote_cache

set :ssh_options, { forward_agent: true }

# See http://stackoverflow.com/questions/9468912/missing-folder-errors-during-capistrano-deploy
set :normalize_asset_timestamps, false

# Set location for apps.
set :location, '198.27.65.229'

role :web, location
role :app, location
role :db, location, primary: true

after 'deploy:update', 'deploy:restart'

# Post-deploy tasks.
namespace :deploy do

  desc "Start the application services"

  # thin restart -P /var/www/getsyme.com/shared/thin.pid -l /var/www/getsyme.com/shared/thin.log -O -e production -s 3 -p 5000
  task :restart, roles: :app do

    pid_path = "#{shared_path}/thin.pid"
    log_path = "#{shared_path}/thin.log"
    
    thin_opts = "-P #{pid_path} -l #{log_path} -O"
    thin_call = "-e production -s 3 -p 5000 #{thin_opts}"
    
    run "cd /var/www/getsyme.com/current && " +
        "bundle install && " +
        "thin restart #{thin_call}"

  end

end