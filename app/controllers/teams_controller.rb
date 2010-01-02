class TeamsController < ApplicationController
  
  before_filter :authorize, :get_organisation, :get_user, :authorize_as_readwrite
    
  # GET /teams
  # GET /teams.xml
  def index
    @teams = @organisation.teams

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    if session[:administrator]
      @team = Team.find(params[:id])
    else
      @team = @organisation.teams.find(params[:id])
    end    
  end

  # POST /teams
  # POST /teams.xml
  def create
    @team = Team.new(params[:team])
    @team.organisation_id = @organisation.id #team belongs to currently logged in organisation
    
    respond_to do |format|
      if @team.save
        flash.now[:notice] = 'Your new team has been created.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    
    if session[:administrator]
      @team = Team.find(params[:id])
    else
      @team = @organisation.teams.find(params[:id])
    end

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash.now[:notice] = 'Your team was successfully updated.'
        format.html { render :action => "edit" }
      else
        format.html { render :action => "edit" }
      end
    end    
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    if session[:administrator]
      @team = Team.find(params[:id])
    else
      @team = @organisation.teams.find(params[:id])
    end
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url) }
    end
  end
end
