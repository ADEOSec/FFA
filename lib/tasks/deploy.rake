namespace :deploy do
	desc "Prepare deploy"
	task prepare: :environment do
		file = Rails.root.join('config/application.yml')
		
		# Open YAML file
		config = YAML.load_file(file)
		
		# Secret Key Base
		puts "Enter your secret key: "
		config["secret_key_base"] = STDIN.gets.chomp.to_s
		
		# Server ip
		puts "Enter your server ip: "
		config["server_ip"] = STDIN.gets.chomp.to_s
		
		# Domain name
		puts "Enter your domain name: "
		config["domain_name"] = STDIN.gets.chomp.to_s
		
		# Repo url
		puts "Enter your repository url: "
		config["repo_url"] = STDIN.gets.chomp.to_s
		
		# Mail address
		puts "Enter your mail address: "
		config["mail_address"] = STDIN.gets.chomp.to_s
		
		# SMTP server
		puts "Enter your smtp server: "
		config["smtp_server"] = STDIN.gets.chomp.to_s
		
		# SMTP port
		puts "Enter your smtp port: "
		config["smtp_port"] = STDIN.gets.chomp.to_i
		
		# SMTP domain
		puts "Enter your smtp domain: "
		config["smtp_domain"] = STDIN.gets.chomp.to_s
		
		# SMTP auth
		puts "Enter your smtp auth type(:login, :plain, vs.): "
		config["smtp_auth"] = STDIN.gets.chomp
		
		# SMTP user
		puts "Enter your smtp user: "
		config["smtp_user"] = STDIN.gets.chomp.to_s
		
		# SMTP pass
		puts "Enter your smtp password: "
		config["smtp_pass"] = STDIN.gets.chomp.to_s
		
		# SMTP tls
		puts "Enter your smtp start with tls(true/false): "
		config["smtp_tls"] = STDIN.gets.chomp
		
		# Save YAML file
		File.open(file, 'w') {|f| f.write config.to_yaml }
	end
	
	task set: :environment do
		config_file = Rails.root.join('config/application.yml')
		deploy_file = Rails.root.join('config/deploy.rb')
		deploy_production_file = Rails.root.join('config/deploy/production.rb')
		env_production_file = Rails.root.join('config/environments/production.rb')
		devise_file = Rails.root.join('config/initializers/devise.rb')
		secrets_file = Rails.root.join('config/secrets.yml')
		
		config = YAML.load_file(config_file)
		if config['repo_url'].empty? or config['server_ip'].empty? or config['domain_name'].empty?
			abort "Please run this command: bundle exec rake deploy:prepare"
		end
		
		puts "Set deploy.rb values"
		file_content = File.read(deploy_file)
		file_content.gsub!('#{REPO_URL}', "\"#{config['repo_url']}\"")
		File.open(deploy_file, 'w') {|f| f.write file_content}
		
		puts "Set production.rb values"
		file_content = File.read(deploy_production_file)
		file_content.gsub!('#{SERVER_IP}', "\"#{config['server_ip']}\"")
		file_content.gsub!('#{DOMAIN_NAME}', "\"#{config['domain_name']}\"")
		File.open(deploy_production_file, 'w') {|f| f.write file_content}
		
		puts "Set environments production.rb values"
		file_content = File.read(env_production_file)
		file_content.gsub!('#{DOMAIN_NAME}', "\"#{config['domain_name']}\"")
		file_content.gsub!('#{SMTP_SERVER}', "\"#{config['smtp_server']}\"")
		file_content.gsub!('#{SMTP_PORT}', "#{config['smtp_port']}")
		file_content.gsub!('#{SMTP_DOMAIN}', "\"#{config['smtp_domain']}\"")
		file_content.gsub!('#{SMTP_AUTH}', "#{config['smtp_auth']}")
		file_content.gsub!('#{SMTP_USER}', "\"#{config['smtp_user']}\"")
		file_content.gsub!('#{SMTP_PASS}', "\"#{config['smtp_pass']}\"")
		file_content.gsub!('#{SMTP_TLS}', "#{config['smtp_tls']}")
		File.open(env_production_file, 'w') {|f| f.write file_content}
		
		puts "Set devise values"
		file_content = File.read(devise_file)
		file_content.gsub!('#{MAIL_ADDRESS}', "\"#{config['mail_address']}\"")
		File.open(devise_file, 'w') {|f| f.write file_content}
		
		puts "Set secrets file"
		file_content = File.read(secrets_file)
		file_content.gsub!('#{SECRET_KEY_BASE}', "#{config['secret_key_base']}")
		File.open(secrets_file, 'w') {|f| f.write file_content}
	end
end