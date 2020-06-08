# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'labs'
set :repo_url, 'git@github.com:unepwcmc/labs.git'

#set :branch, 'master'

set :deploy_user, 'wcmc'
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

set :rvm_type, :user
set :rvm_ruby_version, '2.2.3'

set :pty, true


set :ssh_options, {
  forward_agent: true,
}

set :linked_files, %w{config/database.yml config/config.yml config/secrets.yml}

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :keep_releases, 5

set :passenger_restart_with_touch, false


require 'yaml'
require 'json'
secrets =  YAML.load(File.open('config/secrets.yml'))

set :slack_token, secrets["slack_token"] # comes from inbound webhook integration
set :slack_room, "#labs"
set :slack_subdomain, "wcmc" # if your subdomain is kohactive.slack.com
set :slack_application, "Labs"
set :slack_username, "Capistrano"
set :slack_emoji, ":thumbsup:"


