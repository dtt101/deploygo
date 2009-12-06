class AllocationsController < ApplicationController
  
  before_filter :authorize_as_admin, :get_organisation, :get_user
  
  # GET /allocations
  # GET /allocations.xml
  def index
    projects = @organisation.projects
    allocations = []
    projects.each do |project|
      allocations = allocations + project.allocations
    end
    @allocations = allocations
    @allocations.each do |a|
      strnoworks = a.allocation_date.to_s(:db)
      a.allocation_date = strnoworks.to_date
      a.save
    end
    # TODO - end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @allocations }
    end
  end

  # GET /allocations/1
  # GET /allocations/1.xml
  def show
    @allocation = Allocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @allocation }
    end
  end

  # GET /allocations/new
  # GET /allocations/new.xml
  def new
    @allocation = Allocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @allocation }
    end
  end

  # GET /allocations/1/edit
  def edit
    @allocation = Allocation.find(params[:id])
  end

  # POST /allocations
  # POST /allocations.xml
  def create
    @allocation = Allocation.new(params[:allocation])

    respond_to do |format|
      if @allocation.save
        flash[:notice] = 'Allocation was successfully created.'
        format.html { redirect_to(@allocation) }
        format.xml  { render :xml => @allocation, :status => :created, :location => @allocation }
        format.js {}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @allocation.errors, :status => :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /allocations/1
  # PUT /allocations/1.xml
  def update
    @allocation = Allocation.find(params[:id])

    respond_to do |format|
      if @allocation.update_attributes(params[:allocation])
        flash[:notice] = 'Allocation was successfully updated.'
        format.html { redirect_to(@allocation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @allocation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /allocations/1
  # DELETE /allocations/1.xml
  def destroy
    @allocation = Allocation.find(params[:id])
    @allocation.destroy

    respond_to do |format|
      format.html { redirect_to(allocations_url) }
      format.xml  { head :ok }
    end
  end
end
