class HomeController < ApplicationController
  # GET /
  def index

    @charts = []

    Site.all.each do |site|
      site.environments.each do |environment|
        chart = environment.charts.where(:series =>
          'unhealthy_checkups_sum').first
        @charts << {
          :name => "#{site.name} #{environment.name}",
          :data => chart.data
        }
      end
    end

    @starts_at = Chart.first.starts_at
    @ends_at = Chart.first.ends_at    
    @point_interval = 1.day * 1000
    @point_start = @starts_at.to_i * 1000
    @subtitle = "#{l @starts_at} through #{l @ends_at}"

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
