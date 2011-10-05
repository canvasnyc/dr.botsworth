class EnvironmentsController < ApplicationController
  # GET /sites/1/environments
  # GET /sites/1/environments.json
  def index
    @site = Site.find(params[:site_id])
    @environments = @site.environments.where(:site_id => params[:site_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @environments }
    end
  end

  # GET /sites/1/environments/1
  # GET /sites/1/environments/1.json
  def show
    @site = Site.find(params[:site_id])
    @environment = @site.environments.find(params[:id])
    @checkups = @environment.checkups.order('created_at desc').page params[:page]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @environment }
    end
  end

  # GET /sites/1/environments/new
  # GET /sites/1/environments/new.json
  def new
    @site = Site.find(params[:site_id])
    @environment = @site.environments.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @environment }
    end
  end

  # GET /sites/1/environments/1/edit
  def edit
    @site = Site.find(params[:site_id])
    @environment = @site.environments.find(params[:id])
  end

  # POST /sites/1/environments
  # POST /sites/1/environments.json
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

  # PUT /sites/1/environments/1
  # PUT /sites/1/environments/1.json
  def update
    @site = Site.find(params[:site_id])
    @environment = @site.environments.find(params[:id])

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

  # DELETE /sites/1/environments/1
  # DELETE /sites/1/environments/1.json
  def destroy
    @site = Site.find(params[:site_id])
    @environment = @site.environments.find(params[:id])
    @environment.destroy

    respond_to do |format|
      format.html { redirect_to site_environments_path }
      format.json { head :ok }
    end
  end

  # GET /sites/1/environments/1/test_alert
  def test_alert
    @site = Site.find(params[:site_id])
    @environment = @site.environments.find(params[:id])

    result = @environment.test_alert

    respond_to do |format|
      unless result[:error]
        format.html { redirect_to site_environment_path(@site, @environment), :notice => result[:message] }
      else
        format.html { redirect_to site_environment_path(@site, @environment), :alert => result[:message] }
      end
    end
  end

end
