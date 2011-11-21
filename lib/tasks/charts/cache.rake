namespace :charts do
  desc "Caches chart data for each environment"
  task :cache => :environment do
    Site.all.each do |site|
      site.environments.all.each do |environment|
        puts "Caching chart data for environment: #{site.name} #{environment.name}..."
        Chart.cache!(environment.id)
      end
    end
  end
end
