set :stage, :production # change environment
set :branch, 'master' # change git brunch name
set :server_name, "184.164.90.50"
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
#
#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}

# set your own server's IP

role :web, "184.164.90.50 " # Your HTTP server, Apache/etc
role :app, "184.164.90.50 " # This may be the same as your `Web` server
role :db, "184.164.90.50 ", :primary => true # This is where Rails migrations will run

set :deploy_to, '/home/imtiaz/apps/islamjanun' # change the directory of project

set 'rails_env', :production

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

#server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    password: '********', # change to your password
    user: 'imtiaz',  # change to your server SSH user
}