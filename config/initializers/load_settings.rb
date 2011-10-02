Settings = Hashie::Mash.new(YAML.load_file(File.join(Rails.root, '/config/settings.yml'))[Rails.env])
