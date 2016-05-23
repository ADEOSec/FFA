namespace :rails do

  desc 'Open a rails console `cap [staging] rails:console [server_index default: 0]`'
  task :console do
    server = roles(:app)[ARGV[2].to_i]
    puts "Opening a console on: #{server.hostname}…."
    cmd = "ssh #{server.user}@#{server.hostname} -tp #{server.port} 'cd #{fetch(:current_path)} && RAILS_ENV=#{fetch(:rails_env)} #{fetch(:run_path)}bundle exec rails console'"
    puts cmd
    exec cmd
  end

end