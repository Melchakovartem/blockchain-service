server "217.67.186.187", user: "manage", roles: %w{app db web}, primary: true
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
# server "db.example.com", user: "deploy", roles: %w{db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{manage@217.67.186.187}
role :web, %w{manage@217.67.186.187}
role :db,  %w{manage@217.67.186.187}

set :rails_env, :production

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.


# Global options
# --------------
  set :ssh_options, {
    keys: %w(/Users/user/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey password),
    port: 22  
  }
