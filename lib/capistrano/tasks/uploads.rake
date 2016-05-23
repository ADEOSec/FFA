namespace :uploads do

  desc 'Upload your directory files'
  task :do do
    # your local file root directories
    # TODO change array values
    upload_dirs = ['public/your_upload', 'public/your_image' ]
    # your server upload directory
    upload_to_dir= "#{fetch(:shared_path)}/"

    on roles(:app) do
      upload_dirs.map do |d|
        dir = File.expand_path(d)
        files = Dir.glob("#{dir}/**/**/**/**/**/**")
        files.map do |file|
          name = file[file.index(d)..-1]
          path = "#{upload_to_dir}#{name}"
          puts "File uploading to path: #{path}"
          if File.directory?(file)
            execute "mkdir -p #{path}"
          else
            upload! file,"#{path}"
          end
        end
      end
    end
  end
end