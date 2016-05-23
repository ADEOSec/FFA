namespace :db do
  desc 'Setup db configuration.'
  task :setup do
    on roles(:app) do
      execute "mkdir -p #{fetch(:shared_path)}/config"
      template 'database.yml.erb', "#{fetch(:shared_path)}/config/database.yml"
    end
  end
  desc 'Run rake db:seed.'
  task :seed do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
  desc 'Create empty database file'
  task :create_file do
    on roles(:app) do
      execute :mkdir, '-p', "#{fetch(:shared_path)}/config"
      if test("[ -f #{fetch(:shared_path)}/config/database.yml ]")
        debug "#{fetch(:shared_path)}/config/database.yml file is exist"
      else
        info "#{fetch(:shared_path)}/config/database.yml file does not exist, and it has been created"
        template 'database.yml.erb', "#{fetch(:shared_path)}/config/database.yml"
      end
    end
  end
end
