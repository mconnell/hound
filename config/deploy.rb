set :application, "hound"

set :use_sudo, true

set :scm, "git"
set :repository, "git@github.com:mconnell/#{application}.git"
set :deploy_via, :remote_cache
set :git_enable_submodules, true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/mark/www/#{application}"

set :ssh_options, {:forward_agent => true}

role :app, "97.107.128.150"
role :web, "97.107.128.150"
role :db,  "97.107.128.150", :primary => true

namespace :deploy do
  task :start, :roles => :app do; end
  task :stop, :roles => :app do; end

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :db do
  desc <<-DESC
    Back up the production database. This task dumps the MySQL database in
    production out to an SQL file, then takes a copy of it locally. Generally
    it's good practice to do this before attempting a migration. The second
    part of the task -- copying to the local machine -- may not scale well
    once the database starts to grow, but it's useful for now.
  DESC
  task :backup, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, 'rake')
    rails_env = fetch(:rails_env, 'production')

    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:dump"
  end

  task :download, :roles => :db, :only => { :primary => true } do
    backup
    rails_env = fetch(:rails_env, 'production')
    get "#{current_path}/db/#{rails_env}-data.sql.bz2", "db/#{rails_env}-data.sql.bz2"
  end
end
