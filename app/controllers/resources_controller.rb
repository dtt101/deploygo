class ResourcesController < ApplicationController
  
  before_filter :authorize, :get_organisation, :get_user, :authorize_as_readwrite
  
  # GET /resources
  def index
    @resources = @organisation.resources
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /resources/new
  def new
    @resource = Resource.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /resources/1/edit
  def edit
    if session[:administrator]
      @resource = Resource.find(params[:id])
    else
      @resource = @organisation.resources.find(params[:id])
    end
  end

  # POST /resources
  def create
    resource = Resource.new(params[:resource])
    resource.organisation_id = @organisation.id #resource belongs to currently logged in organisation
    @resource = resource
    limit = @resource.organisation.resource_limit
    respond_to do |format|
      if @resource.organisation.resources.count >= limit 
        flash[:warning] = 'You can only add ' + limit.to_s +  ' resources to your organisation.'
        format.html { render :action => "new" }
      elsif @resource.save
        flash[:notice] = 'Your new resource has been created.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /resources/1
  def update
    if session[:administrator]
      @resource = Resource.find(params[:id])
    else
      @resource = @organisation.resources.find(params[:id])
    end
    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        flash[:notice] = 'Your resource was successfully updated.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    if session[:administrator]
      @resource = Resource.find(params[:id])
    else
      @resource = @organisation.resources.find(params[:id])
    end
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end
end
