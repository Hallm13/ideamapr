require 'dotenv'
Dotenv.load

remote_server = ENV['RAILS_REMOTE_SERVER']
remote_port = ENV['RAILS_REMOTE_PORT']

server remote_server, user: "www-data", port: remote_port, roles: %w(web app db)

set :branch, 'master'
set :rails_env, :production

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
      keys: %w(/where/your/.ssh/keys/are),
      port: remote_port,
    }

set :deploy_to, "/var/www/railsapps/#{fetch(:full_app_name)}"

