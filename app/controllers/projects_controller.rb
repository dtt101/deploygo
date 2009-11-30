class ProjectsController < ApplicationController

  before_filter :authorize, :get_organisation, :get_user, :authorize_as_readwrite

  # GET /projects
  def index
    @projects = @organisation.projects
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /projects/1/edit
  def edit
    if session[:administrator]
      @project = Project.find(params[:id])
    else
      @project = @organisation.projects.find(params[:id])
    end
  end

  # POST /projects
  def create
    project = Project.new(params[:project])
    project.organisation_id = @organisation.id #project belongs to currently logged in organisation
    @project = project
    respond_to do |format|
      if @project.save
        flash.now[:notice] = 'Your new project has been created.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /projects/1
  def update
    if session[:administrator]
      @project = Project.find(params[:id])
    else
      @project = @organisation.projects.find(params[:id])
    end

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash.now[:notice] = 'Your project was successfully updated.'
        format.html { render :action => "edit" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    if session[:administrator]
      @project = Project.find(params[:id])
    else
      @project = @organisation.projects.find(params[:id])
    end
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
    end
  end
  
  def import_basecamp
    respond_to do |format|
      format.html # import_basecamp.html.erb
    end
  end
  
end
