class UsersController < ApplicationController

  before_filter :authorize, :get_organisation, :get_user
  before_filter :authorize_as_readwrite, :except => [:edit, :update]

  # GET /users
  def index
    if session[:administrator]
      @users = User.find(:all, :order => "organisation_id")
    else
      @users = @organisation.users
    end
    @admin = session[:administrator]
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /users/new
  def new
    @thisuser = User.new
    @organisations = Organisation.find(:all, :order => "name").map {|o| [o.name, o.id] } 
    @admin = session[:administrator]
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
    if session[:administrator]
      @thisuser = User.find(params[:id])
    elsif session[:readonlyuser]
      @thisuser = @user # read only users can only edit themselves
    else
      @thisuser = @organisation.users.find(params[:id])
    end
  end

  # POST /users
  def create
    user = User.new(params[:user])
    if session[:administrator]
      # admin can create users for any org
      #logger.info(user.organisation_id)      
    else
      user.organisation_id = @organisation.id #user belongs to currently logged in organisation
    end
    @thisuser = user
    respond_to do |format|
      if @thisuser.save
        flash[:notice] = 'Your new user was successfully created.'
        format.html { redirect_to(:action => 'index') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  def update
    if session[:administrator]
      @thisuser = User.find(params[:id])
    else
      @thisuser = @organisation.users.find(params[:id])
    end
    # if password and password confirmation is empty remove from params to avoid triggering validation
    if (params[:user][:password] == '' and params[:user][:password_confirmation] == '')
      params[:user].delete('password')
      params[:user].delete('password_confirmation')
    end
    if session[:readonlyuser] and (params[:user][:read_only])
      params[:user][:read_only] = true
    end 

    respond_to do |format|
      if @thisuser.update_attributes(params[:user])
        flash.now[:notice] = 'Your user was successfully updated.'
        format.html { render :action => "edit" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if session[:administrator]
      @thisuser = User.find(params[:id])
    else
      @thisuser = @organisation.users.find(params[:id])
    end
    @thisuser.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
  end
end
