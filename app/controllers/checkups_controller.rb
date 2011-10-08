class CheckupsController < ApplicationController

  # GET /checkups
  # GET /checkups.json
  #
  # or
  #
  # GET /sites/1/environments/1/checkups
  # GET /sites/1/environments/1/checkups.json

  def index
    @filters = {}
    @filters[:healthy] = params[:healthy] if params[:healthy].present?

    if params[:environment_id]
      @environment = Environment.find(params[:environment_id])
      @checkups = @environment.checkups.where(@filters).order('created_at desc').page params[:page]
    else
      @checkups = Checkup.where(@filters).order('created_at desc').page params[:page]
    end

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
    @checkup = Checkup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkup }
    end
  end

end
