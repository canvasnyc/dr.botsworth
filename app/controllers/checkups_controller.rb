class CheckupsController < ApplicationController

  # GET /checkups
  # GET /checkups.json
  #
  # or
  #
  # GET /sites/1/environments/1/checkups
  # GET /sites/1/environments/1/checkups.json

  def index
    @filters = params[:filters] || {}
    # Don't bother filtering if a value isn't provided to filter by.
    @filters.delete_if { |k, v| v.empty? }

    if params[:environment_id]
      @environment = Environment.find(params[:environment_id])
      @site = @environment.site
      @checkups = @environment.checkups.where(@filters).order('created_at desc').page params[:page]
    else
      @checkups = Checkup.where(@filters).order('created_at desc').page params[:page]
    end

    @filter_options = {
      :healthy => [[nil, nil], [false, 0], [true, 1]],
      :retries_used => (0..5)
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkups }
    end
  end

  # GET /checkups/1
  # GET /checkups/1.json
  #
  # or
  #
  # GET /sites/1/environments/1/checkups/1
  # GET /sites/1/environments/1/checkups/1.json

  def show
    if params[:environment_id]
      @environment = Environment.find(params[:environment_id])
      @site = @environment.site
      @checkup = @environment.checkups.find(params[:id])
    else
      @checkup = Checkup.find(params[:id])
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkup }
    end
  end

  def chart
    @days = 30

    @environment = Environment.find(params[:environment_id])
    @checkups = @environment.checkups

    bins = self.bins

    @unhealthy_checkups = bins.map { |bin| bin[:unhealthy_checkups_sum] }
    @name_lookup_time = bins.map { |bin| bin[:average_name_lookup_time] }
    @start_transfer_time = bins.map { |bin| bin[:average_start_transfer_time] }
    @total_time = bins.map { |bin| bin[:average_total_time] }
    @retries_used = bins.map { |bin| bin[:retries_used_sum] }

  end

protected

  def bins
    (1..@days).collect do |day|
      min = day.days.ago
      max = (day - 1).days.ago
      @checkups.select(
        'SUM(CASE WHEN `healthy`= 0 THEN 1 ELSE 0 END) AS `unhealthy_checkups_sum`,
        CAST(AVG(`name_lookup_time`) * 1000 AS UNSIGNED) AS `average_name_lookup_time`,
        CAST(AVG(`start_transfer_time`) * 1000 AS UNSIGNED) AS `average_start_transfer_time`,
        CAST(AVG(`total_time`) * 1000 AS UNSIGNED) AS `average_total_time`,
        SUM(`retries_used`) AS `retries_used_sum`'
        ).where(:created_at => min..max).first
    end.reverse
  end

end