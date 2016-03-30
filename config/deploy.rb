# config valid only for current version of Capistrano
lock '3.4.0'

app_name = 'idea_mapr'
set :application, app_name
set :full_app_name, app_name
set :repo_url, "git@github.com:siruguri/#{app_name}.git"

set :bundle_without, [:test]

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/railsapps/my_app_name - this will be overridden in the
# Environment specific deploy config files 
set :deploy_to, "/var/www/railsapps/#{app_name}"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Sidekiq
set :sidekiq_options_per_process, ["--queue scrapers"]
set :sidekiq_monit_default_hooks, false

# Default value for :linked_files is [] - you probably want a Postgres database in production, not SQLite3
set :linked_files, fetch(:linked_files, []).push('.env', 'config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
