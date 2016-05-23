namespace :unicorn do
  desc 'Unicorn setup'
  task :setup do
    set :unicorn_user, fetch(:local_user)
    set :unicorn_user_group, fetch(:local_user_group)
    set :unicorn_config, "#{fetch(:shared_path)}/config/unicorn.rb"
    set :unicorn_log, "#{fetch(:shared_path)}/log/unicorn.log"
    set :unicorn_workers, 2

    on roles(:app) do
      execute "mkdir -p #{fetch(:shared_path)}/config"
      template 'unicorn.rb.erb', fetch(:unicorn_config)
      template 'unicorn_init.erb', "#{fetch(:shared_path)}/config/unicorn_init.sh"
      execute "chmod +x #{fetch(:shared_path)}/config/unicorn_init.sh"
      sudo "ln -nfs #{fetch(:shared_path)}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
    end
  end

  %w[start stop restart].each do |command|
    desc "Unicorn server #{command}."
    task command do
      on roles(:app), in: :groups, limit: 3, wait: 4 do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  desc "Unicorn server upgrade."
  task :upgrade do
    on roles(:app), in: :groups, limit: 3, wait: 1 do
      execute "/etc/init.d/unicorn_#{fetch(:application)} upgrade"
    end
  end
end