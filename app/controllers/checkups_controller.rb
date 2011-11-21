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
    @environment = Environment.find(params[:environment_id])
    @site = @environment.site
    charts = @environment.charts

    @starts_at = charts.first.starts_at
    @ends_at = charts.first.ends_at    
    @point_interval = 1.day * 1000
    @point_start = @starts_at.to_i * 1000


    @charts = {
      :name_lookup_time =>
        charts.where(:series => 'average_name_lookup_time').first,
      :start_transfer_time =>
        charts.where(:series => 'average_start_transfer_time').first,
      :total_time =>
        charts.where(:series => 'average_total_time').first,
      :unhealthy_checkups =>
        charts.where(:series => 'unhealthy_checkups_sum').first,
      :retries_used =>
        charts.where(:series => 'retries_used_sum').first,
      :downloaded_bytes =>
        charts.where(:series => 'average_downloaded_bytes').first
    }

  end

end