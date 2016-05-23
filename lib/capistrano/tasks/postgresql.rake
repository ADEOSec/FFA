namespace :postgresql do

  desc 'Setup postgresql for application'
  task :setup do
    # Ask information
    ask :postgresql_user, "Postgresql username"
    puts fetch(:postgresql_user)
    ask :postgresql_password, "Postgresql password for #{fetch(:postgresql_user)}"
    puts fetch(:postgresql_password)
    ask :postgresql_database, "Postgresql database"
    puts fetch(:postgresql_database)
    ask :create_db_user, "Create database user? Yes(y) or No(n)"
    puts fetch(:create_db_user)
    ask :create_db, "Create database? Yes(y) or No(n)"
    puts fetch(:create_db)
    ask :use_hipchat, "Do you want to add hipchat token? Yes(y) or No(n)"
    puts fetch(:use_hipchat)
    if fetch(:use_hipchat).casecmp('y') == 0
      ask :hipchat_token, "Hipchat token"
      puts fetch(:hipchat_token)
    end

    # Run queries
    on roles(:app) do

      if fetch(:create_db_user).casecmp('y') == 0
        puts 'Creating user with password'
        # Create database user
        sudo %Q{sudo -u postgres psql -c "create user #{fetch(:postgresql_user)} with password '#{fetch(:postgresql_password)}';"}
      end
      if fetch(:create_db).casecmp('y') == 0
        puts 'Creating database with owner'
        sudo %Q{sudo -u postgres psql -c "create database "#{fetch(:postgresql_database)}_#{fetch(:rails_env)}" owner #{fetch(:postgresql_user)} encoding 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' TEMPLATE template0;"}
      end
      puts 'Creating database.yml.'
      # Configure database settings
      execute "mkdir -p #{fetch(:shared_path)}/config"
      template 'database.yml.erb', "#{fetch(:shared_path)}/config/database.yml"

      # puts 'Creating backup model.'
      # # Check model is exist
      # full_path = "/home/#{fetch(:local_user)}/Backup/models/#{fetch(:application)}.rb"
      # if 'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
      #   execute "mv #{full_path} #{full_path}.#{Time.now.to_i}"
      # end
      # # Generate new model
      # gem_execute "backup generate:model -t #{fetch(:application)} --storages=local --compressor=gzip --databases=postgresql"
      # execute "rm #{full_path}"
      # template 'backup_model.erb', full_path
      # puts "Now edit #{full_path}"

    end
  end

  desc 'Restart postgresql'
  task :restart do
    on roles(:app) do
      puts 'Postgresql restarting'
      sudo 'service postgresql restart'
    end
  end

end