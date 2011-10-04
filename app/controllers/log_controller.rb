class LogController < ApplicationController

  # GET /log/100
  def show
    @lines = params[:lines]
    @log = Log.read(@lines)

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end