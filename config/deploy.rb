set :default_stage, 'staging'
require 'capistrano/ext/multistage'

require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'

set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"

## Generated with 'brightbox' on Thu Apr 21 11:12:49 +0100 2011
gem 'brightbox', '>=2.3.8'
require 'brightbox/recipes'
require 'brightbox/passenger'

load 'deploy/assets'
# The name of your application.  Used for deployment directory and filenames
# and Apache configs. Should be unique on the Brightbox
set :application, "labs"
set :sudo_user, "rails"
set :app_port, "80"

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", user, application) }
set :repository, "git@github.com:unepwcmc/labs.git"

set :branch, :master
set :scm, :git
set :branch, "master"
set :scm_username, "unepwcmc-read"
set :git_enable_submodules, 1
default_run_options[:pty] = true # Must be set for the password prompt from git to work

## Dependencies
# Set the commands and gems that your application requires. e.g.
# depend :remote, :gem, "will_paginate", ">=2.2.2"
# depend :remote, :command, "brightbox"
#
# Specify your specific Rails version if it is not vendored
#depend :remote, :gem, "rails", "=2.3.8"
#depend :remote, :gem, "authlogic", "=2.1.4"
#depend :remote, :gem, "faker", "=0.9.5"
#depend :remote, :gem, "hashie", "=0.2.0"
#depend :remote, :gem, "pg", "=0.11.0"

## Local Shared Area
# These are the list of files and directories that you want
# to share between the releases of your application on a particular
# server. It uses the same shared area as the log files.
#
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :local_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :local_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
set :local_shared_files, %w(config/database.yml config/initializers/rails_admin.rb config/config.yml
                           config/secrets.yml)
set :local_shared_dirs, %w(public/system)

desc "Configure VHost"
task :config_vhost do
vhost_config =<<-EOF
server {
  listen 80;
  client_max_body_size 4G;
  server_name #{application}.#{server};
  keepalive_timeout 5;
  root #{deploy_to}/current/public;
  passenger_enabled on;
  rails_env #{rails_env};

  add_header 'Access-Control-Allow-Origin' *;
  add_header 'Access-Control-Allow-Methods' "GET, POST, PUT, DELETE, OPTIONS";
  add_header 'Access-Control-Allow-Headers' "X-Requested-With, X-Prototype-Version";
  add_header 'Access-Control-Max-Age' 1728000;
  
  gzip on;
  location ^~ /assets/ {
    expires max;
    add_header Cache-Control public;
  }
  
  if (-f $document_root/system/maintenance.html) {
    return 503;
  }

  error_page 500 502 504 /500.html;
  location = /500.html {
    root #{deploy_to}/public;
  }

  error_page 503 @maintenance;
  location @maintenance {
    rewrite  ^(.*)$  /system/maintenance.html break;
  }
}
EOF
put vhost_config, "/tmp/vhost_config"
sudo "mv /tmp/vhost_config /etc/nginx/sites-available/#{application}"
sudo "ln -s /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"
end
 
after "deploy:setup", :config_vhost

task :setup_production_database_configuration do
  the_host = Capistrano::CLI.ui.ask("Database IP address: ")
  database_name = Capistrano::CLI.ui.ask("Database name: ")
  database_user = Capistrano::CLI.ui.ask("Database username: ")
  pg_password = Capistrano::CLI.password_prompt("Database user password: ")
  require 'yaml'
  spec = { "staging" => {
    "adapter" => "postgresql",
    'encoding' => 'utf-8',
    "database" => database_name,
    "username" => database_user,
    "host" => the_host,
    "password" => pg_password }}
    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/database.yml")
end
after "deploy:setup", :setup_production_database_configuration

desc 'Generate rails_admin.rb initializer file'
task :generate_rails_admin do
  secret_password = Capistrano::CLI.ui.ask("Enter your secret access password (Rails Admin initializer):")
  template = File.read("config/deploy/rails_admin.rb.erb")
  buffer = ERB.new(template).result(binding)
  put buffer, "#{shared_path}/config/initializers/rails_admin.rb"
end
after "deploy:setup", :generate_rails_admin

desc 'Generate config file'
task :generate_config_file do
  toggl_token = Capistrano::CLI.ui.ask("Enter toggl token:")
  toggl_ws_id = Capistrano::CLI.ui.ask("Enter toggl workspace id:")
  pt_token = Capistrano::CLI.ui.ask("Enter pivotal tracker token:")
  ducksboard_api_token = Capistrano::CLI.ui.ask("Enter ducksboard api token:")
  nagios_uname = Capistrano::CLI.ui.ask("Enter nagios username:")
  nagios_pwd = Capistrano::CLI.ui.ask("Enter nagios password:")
  template = File.read("config/config.yml.erb")
  buffer = ERB.new(template).result(binding)
  put buffer, "#{shared_path}/config/config.yml"
end
after "deploy:setup", :generate_config_file

task :update_dashboard do
  run "cd #{current_path} && bundle exec rake dashboard:update_all RAILS_ENV=#{rails_env}"
end
#after :deploy, :update_dashboard
