# config valid only for current version of Capistrano
lock '3.8.2'

set :application, 'labs'
set :repo_url, 'git@github.com:unepwcmc/labs.git'

set :ssh_options, keys: ["config/deploy_id_rsa"] if File.exist?("config/deploy_id_rsa")

set :branch, 'master'

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


set :slackistrano, {
   channel: ENV.fetch('SLACK_CHANNEL'),
   klass: Slackistrano::CustomMessaging,
   webhook: ENV.fetch('SLACK_WEBHOOK_URL')
}
