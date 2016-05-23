# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'FFA'
set :repo_url, #{REPO_URL}

set :local_user, 'deploy'
set :stages, %w(production)
set :default_stage, 'production'
set :deploy_to, "/home/#{fetch(:local_user)}/apps/#{fetch(:application)}"
set :scm, :git
set :pty, true
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/upload', 'public/images', 'public/seat_images')
set :default_env, { path: '/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH' }
load 'config/deploy/recipes/base.rb'

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end
