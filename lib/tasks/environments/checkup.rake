namespace :environments do
  desc "Performs health checkups on each environment"
  task :checkup => :environment do

    ip_relay = IPRelay::Downtime.new(Settings.ip_relay)

    Site.all.each do |site|
      puts "\nChecking health of site #{site.name}"

      site.environments.all.each do |environment|
        print "Is #{environment.name} environment healthy? "
        STDOUT.flush
        checkup = Checkup.new
        checkup.environment = environment
        checkup.perform

        puts "#{checkup.healthy} #{"(#{checkup.error})" if checkup.error.present?}"

        unless checkup.healthy?
          ip_relay.alert({
            :url => environment.url,
            :id => environment.id,
            :site => site.name,
            :commands => environment.ip_relay_commands,
            :environment => environment.name,
            :message => checkup.error
           })
        end

      end
    end

  end
end
