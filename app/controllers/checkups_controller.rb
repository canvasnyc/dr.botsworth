class CheckupsController < ApplicationController

  # GET /checkups
  # GET /checkups.json
  def index
    @checkups = Checkup.order('created_at desc').page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkups }
    end
  end

  # GET /checkups/1
  # GET /checkups/1.json
  def show
    @checkup = Checkup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkup }
    end
  end

end
