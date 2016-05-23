namespace :nginx do

  desc 'Nginx setup.'
  task :setup do
    on roles(:app) do
      puts "Creating #{fetch(:shared_path)}/config/nginx.#{fetch(:rails_env)}.conf"
      template "nginx.#{fetch(:rails_env)}.erb", "#{fetch(:shared_path)}/config/nginx.#{fetch(:rails_env)}.conf"

      puts "Symlinks #{fetch(:shared_path)}/config/nginx.#{fetch(:rails_env)}.conf to /etc/nginx/sites-enabled/#{fetch(:application)}"
      sudo "ln -nfs #{fetch(:shared_path)}/config/nginx.#{fetch(:rails_env)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}"

    end
  end

  %w[start stop restart reload].each do |command|
    desc "Nginx #{command}"
    task command do
      on roles(:app), in: :groups, limit: 2, wait: 2 do
        sudo "service nginx #{command}"
      end
    end
  end

end