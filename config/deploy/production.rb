server #{SERVER_IP}, user: "#{fetch(:local_user)}", roles: %w{app db web},
       primary: true, port: 22

set :rails_env, 'production'
set :branch, 'master'
set :project_domain, #{DOMAIN_NAME}