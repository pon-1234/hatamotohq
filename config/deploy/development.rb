# frozen_string_literal: true

server '18.176.164.49', port: 22, roles: %i[web app db], primary: true
set :repo_url,        'git@github.com:pon-1234/hatamotohq.git'
set :application,     'line-insight'
set :user,            'deploy'
set :ssh_options, {
  keys: %w[/home/runner/.ssh/id_rsa ~/.ssh/yopaz],
  user: fetch(:user),
  forward_agent: true,
  auth_methods: %w[publickey],
  port: 22
}
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

set :stage, :production
set :branch, 'develop'
