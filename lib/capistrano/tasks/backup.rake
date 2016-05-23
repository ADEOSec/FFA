# namespace :backup do
#   desc 'Setup backup.'
#   task :setup do
#     on roles(:app) do
#       puts 'Creating backup model.'
#
#       # Check model is exist
#       full_path = "/home/#{fetch(:local_user)}/Backup/models/#{fetch(:application)}.rb"
#       if 'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
#         execute "mv #{full_path} #{full_path}.#{Time.now.to_i}"
#       end
#
#       # Generate new model
#       gem_execute "backup generate:model -t #{fetch(:application)} --storages=local --compressor=gzip --databases=postgresql"
#       execute "rm #{full_path}"
#       template 'backup_model.erb', full_path
#       puts "Now edit #{full_path}"
#     end
#   end
#
#   desc 'Get backup.'
#   task :perform do
#     on roles(:app) do
#       puts 'Performing backup.'
#       gem_execute "backup perform --trigger #{fetch(:application)}"
#     end
#   end
#
# end