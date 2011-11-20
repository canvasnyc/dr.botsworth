namespace :environments do
  desc "Performs health checkup on each environment"
  task :checkup => :environment do

    puts "\nStart: #{Time.now}"

    Site.all.each do |site|
      puts "\nChecking health of site #{site.name}"

      # Iterate through each environment associated with this site
      site.environments.all.each do |environment|
        print "Is #{environment.name} environment healthy? "
        # Cause the console output to refresh in case someone is watching this
        # live.
        STDOUT.flush
        checkup = Checkup.new
        # Set the new checkup instance's environment to this environment
        checkup.environment = environment
        checkup.perform
        puts "#{checkup.healthy} #{"(#{checkup.error})" unless checkup.healthy?}"
        # Send the alert (the model will determine whether or not this is
        # necessary).
        checkup.alert
      end
    end

  end
end
