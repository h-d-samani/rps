# Capistrano Config file for a University of Sydney branded Ruby on Rails application.

# Please do a find and replace - find "CHANGEAPPNAME" replace with your new
# app name, which should be the same as your subversion repository name.

# see http://www.rubyrobot.org/article/deploying-rails-20-to-mongrel-with-capistrano-21 for more details

# we now use monit
#require 'mongrel_cluster/recipes'

# see Advanced Rails Recipes 52 & 53
# depends on ruby gem capistrano-ext
set :stages, %w(staging production)
set :default_stage, 'staging'
set(:rails_env) { "#{stage}" }
require 'capistrano/ext/multistage'

require "bundler/capistrano"

set :application, 'rps'
set :repository,  "svn+ssh://roses@agile-svn.ucc.usyd.edu.au/var/svn/repos/#{application}/trunk/"

set :user, 'roses'
set :use_sudo, true

set :http_proxy, "http://web-cache.usyd.edu.au:8080/"
# In order for sudo to work, we now need this:
default_run_options[:pty] = true

set :deploy_to, "/var/www/apps/#{application}"
set :deploy_via, :export

# the proc {} allows lazy evaluation of the stage variable
set(:mongrel_conf) { "#{deploy_to}/current/config/mongrel_cluster_#{stage}.yml" }



# stops the error we get calling 'app' command which doesn't exist, see:
set :runner, nil


task :staging do
  set :ruby_path, "/home/roses/.rvm/wrappers/ruby-1.9.3-p327@global/"
  set :rake, "export PATH=#{ruby_path}:$PATH; bundle exec rake"
  set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; export http_proxy=#{http_proxy}; bundle" # Default is "bundle"
  set :bundle_without, [:test]
  
  set :domain, 'agile-dev.ucc.usyd.edu.au'
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  set :stage, :staging
end

task :production do
  set :ruby_path, "/home/roses/.rvm/wrappers/ruby-1.9.3-p327@global/"
  set :rake, "export PATH=#{ruby_path}:$PATH; bundle exec rake"
  set :bundle_cmd, "export PATH=#{ruby_path}:$PATH; export http_proxy=#{http_proxy}; bundle" # Default is "bundle"
  set :bundle_without, [:test]
  
  set :domain, 'agile1.ucc.usyd.edu.au'
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  set :stage, :production
end

namespace :deploy do
  desc "(Test only) Load fixtures into database"
  task :fixtures do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=staging spec:db:fixtures:load"
  end

  desc "DO NOT RUN in production!!! This will delete live data! Run only in test environment."
  task :reset do
    rake = fetch(:rake, 'rake')
    run "cd #{current_release}; #{rake} RAILS_ENV=#{stage} db:migrate:reset"
  end

  desc "Grants execute permissions on ruby scripts."
  task :update_permissions do
    run "cd #{current_release}; chmod -R ug+x script"
  end

  desc "restart passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "start - not used"
  task :start, :roles => :app do
  end

  desc "stop - not used"
  task :stop, :roles => :app do
  end
end

desc "Tails the log on the remote server"
task :tail_log, :roles => :app do
  stream "tail -f #{shared_path}/log/#{stage}.log"
end

# Install after hooks
after "deploy:update_code", "deploy:update_permissions"

