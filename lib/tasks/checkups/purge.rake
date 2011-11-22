namespace :checkups do
  desc "Purges checkups older than 3 months"
  task :purge => :environment do
    destroyed = Checkup.where("created_at < ?", 3.months.ago).destroy_all
    puts "Purged #{destroyed.count} checkups at #{Time.now}"
  end
end
