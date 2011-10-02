class EnvironmentsController < ApplicationController
  # GET /environments
  # GET /environments.json
  def index
    @site = Site.find(params[:site_id])
    @environments = Environment.where(:site_id => params[:site_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @environments }
    end
  end

  # GET /environments/1
  # GET /environments/1.json
  def show
    @site = Site.find(params[:site_id])
    @environment = Environment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @environment }
    end
  end

  # GET /environments/new
  # GET /environments/new.json
  def new
    @site = Site.find(params[:site_id])
    @environment = @site.environments.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @environment }
    end
  end

  # GET /environments/1/edit
  def edit
    @site = Site.find(params[:site_id])
    @environment = Environment.find(params[:id])
  end

  # POST /environments
  # POST /environments.json
  def create
    @site = Site.find(params[:site_id])
    @environment = @site.environments.new(params[:environment])

    respond_to do |format|
      if @environment.save
        format.html { redirect_to site_environment_path(@site, @environment), :notice => 'Environment was successfully created.' }
        format.json { render :json => @environment, :status => :created, :location => @environment }
      else
        format.html { render :action => "new" }
        format.json { render :json => @environment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /environments/1
  # PUT /environments/1.json
  def update
    @site = Site.find(params[:site_id])
    @environment = Environment.find(params[:id])

    respond_to do |format|
      if @environment.update_attributes(params[:environment])
        format.html { redirect_to site_environment_path(@site, @environment), :notice => 'Environment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @environment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /environments/1
  # DELETE /environments/1.json
  def destroy

    @environment = Environment.find(params[:id])
    @environment.destroy

    respond_to do |format|
      format.html { redirect_to site_environments_path }
      format.json { head :ok }
    end
  end
end
