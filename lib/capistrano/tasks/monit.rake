namespace :monit do

  desc 'Install Monit'
  task :install do
    on roles(:app) do
      sudo "apt-get -y install monit"
    end
  end

  desc 'Setup all Monit configuration'
  task :setup do
    on roles(:app) do
      monit_config 'monitrc', '/etc/monit/monitrc'
      invoke 'monit:nginx'
      invoke 'monit:postgresql'
      invoke 'monit:unicorn'
      invoke 'monit:syntax'
      invoke 'monit:reload'
    end
  end

  task :nginx do
    on roles(:app) do
      monit_config "nginx"
    end
  end
  task :postgresql do
    on roles(:app) do
      monit_config "postgresql"
    end
  end
  task :unicorn do
    on roles(:app) do
      monit_config "unicorn"
    end
  end

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:app) do
        sudo "service monit #{command}"
      end
    end
  end

end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  sudo "mv /tmp/monit_#{name} #{destination}"
  sudo "chown root #{destination}"
  sudo "chmod 600 #{destination}"
end
