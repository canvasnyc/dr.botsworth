class LogController < ApplicationController

  # GET /log/100
  def show
    @log = Log.read(params[:lines])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end