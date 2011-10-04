namespace :environments do
  desc "Performs health checkup on each environment"
  task :checkup => :environment do

    puts "\nStart: #{Time.now}"

    Site.all.each do |site|
      puts "\nChecking health of site #{site.name}"

      site.environments.all.each do |environment|
        print "Is #{environment.name} environment healthy? "
        STDOUT.flush
        checkup = Checkup.new
        checkup.environment = environment
        checkup.perform
        puts "#{checkup.healthy} #{"(#{checkup.error})" unless checkup.healthy?}"
        Alert.send(checkup)
      end
    end

  end
end
