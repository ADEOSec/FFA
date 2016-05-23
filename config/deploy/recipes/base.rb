set :shared_path, "#{fetch(:deploy_to)}/shared"
set :current_path, "#{fetch(:deploy_to)}/current"
set :postgresql_pid, "/var/run/postgresql/9.3-main.pid"
set :unicorn_pid, "#{fetch(:current_path)}/tmp/pids/unicorn.pid"
set :postgresql_host, 'localhost'
set :postgresql_port, '5432'
set :run_path, '$HOME/.rbenv/shims/'
set :maintenance_template_path, File.expand_path('../templates/maintenance.html.erb', __FILE__)
# local user group on server. We use deploy group
set :local_user_group, fetch(:local_user)

# Use template
def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  File.open(File.expand_path("tmp/temprory"), 'w') { |file| file.write(ERB.new(erb).result(binding)) }
  upload! File.expand_path("tmp/temprory"), to
end

# Gem execute path
def gem_execute(command)
  execute  "#{fetch(:run_path)}#{command}"
end

namespace :deploy do
  ## If you want to use maintenance mode during deploy, use Scenario 1
  ## Scenario 1 with maintenance mode
  # before 'deploy', 'backup:perform'
  # before 'deploy', 'maintenance:enable'
  # after 'deploy', 'deploy:cleanup'
  # after 'deploy', 'deploy:cleanup_assets'
  # after 'deploy', 'unicorn:stop'
  # after 'unicorn:stop', 'unicorn:start'
  # after 'unicorn:start', 'maintenance:disable'

  ## We use default zero down time
  ## If you want to use zero down time deployment use this Scenario
  ## Scenario 2 without maintenance mode
  # before 'deploy', 'backup:perform'
  after 'deploy', 'deploy:cleanup'
  after 'deploy', 'deploy:cleanup_assets'
  before 'unicorn:upgrade', 'maintenance:enable'
  after 'deploy', 'unicorn:upgrade'
  after 'unicorn:upgrade', 'unicorn:stop'
  after 'unicorn:stop', 'unicorn:start'
  after 'unicorn:start', 'maintenance:disable'

  desc <<-DESC
    Prepare environment for first deploy. You can use this command for first deploy
    This command invokes
    - db:create_file
    - deploy(starting updating publishing finishing)
    - postgresql:setup
    - nginx:setup
    - unicorn:setup
    - bundler:install
    - nginx:restart
    - deploy
  DESC
  task :prepare do
    puts 'prepare'
    invoke 'db:create_file'
    %w{starting updating publishing finishing}.each do |task|
      invoke "deploy:#{task}"
    end
    invoke 'postgresql:setup'
    invoke 'nginx:setup'
    invoke 'unicorn:setup'
    invoke 'bundler:install'
    invoke 'nginx:restart'
    invoke 'deploy'
    ## Remove comments if you are using monit
    invoke 'monit:install'
    invoke 'monit:setup'
  end

end