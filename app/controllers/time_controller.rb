require 'json/add/rails'

class TimeController < ApplicationController

  before_filter :authorize, :get_organisation, :get_user
  before_filter :authorize_as_readwrite, :except => [:index, :set_team]
  
  def index
    # get projects and resources
    @projects = @organisation.projects.by_archive_status(false)
    @teams = @organisation.teams
    if session[:team_id]
      @team = @organisation.teams.find(session[:team_id])
      @resources = @team.resources
    else
      @resources = @organisation.resources
    end
    # create a new allocation for the form
    @allocation = Allocation.new
    
    # sort out start time - default to current week as start & show 2 weeks
    starttime = Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i).to_time rescue Time.now
    # default
    @startdate = starttime.at_beginning_of_week.to_date
    @enddate = starttime.at_beginning_of_week.advance(:days => 13).to_date
    
    # fix the startdate and enddate of the allocation to prepopulate form, both the same makes it easier for user
    # TODO - these can probably now be removed - test and see
    @allocation.date_from = @startdate
    @allocation.date_to = @startdate
    
    #find projects that are due between the start and end date
    @projects_due = @projects.due_on_or_after(@startdate).due_on_or_before(@enddate)

    # so sort out dates for moving forwards and backwards
    @lastweek = @startdate - 7
    @nextweek = @startdate + 7
    
    # finally set template variable that will prevent ordinary drag selection from working
    @stopdefaultdrag = true
  end
  
  # takes a json allocations array of : {'resource_id':resource_id, 'allocation_date':allocation_date, 'project_id':project_id}
  # creates allocations, tests if valid then creates in database
  def create
    allocations = JSON.parse(params['allocations'])
    @allocations = []
    allocations.each do | a |
      allocation = Allocation.new
      allocation.resource_id = a['resource_id']
      allocation.project_id = a['project_id']
      # parse to date - as oppose to time to ensure date format understood by db
      allocation.allocation_date = Date.parse(a['allocation_date']);
      # check the supplied ids apply to the current organisation
      if @organisation.projects.find(allocation.project_id) and @organisation.resources.find(allocation.resource_id)      
        # check if weekends are excluded for project - if so do not create
        workdays = Range.new(1, 5)
        if allocation.project.include_weekends
          workdays = Range.new(0, 6)
        end
        if workdays === allocation.allocation_date.wday()
          if !allocation.save
            saved = false
          else
            @allocations << allocation
          end
        end        
      end
      respond_to do |format|
        format.html { redirect_to 'index' }
        format.js {}
      end
    end
  end

  # destroys allocations in provided json dictionary
  def destroy
    allocation_ids = JSON.parse(params['allocations'])
    @allocations = []
      allocation_ids.each do | a |      
        allocation = Allocation.find(a['allocation_id'])
        organisation = Organisation.find(session[:organisation_id])
        project = organisation.projects.find(allocation.project.id)
        # check if project in allocation belongs to currently logged in organisation
        if project
          @allocations << allocation
          allocation.destroy
        end
      end
      respond_to do |format|
        format.html { redirect_to 'index' }
        format.js  { }
      end  
  end
  
  def set_team
    team_id = params[:id]
    if team_id == "0"
      session[:team_id] = nil
    else
      team = @organisation.teams.find(team_id)
      if team 
        session[:team_id] = team_id
      end
    end
    redirect_to(:back)
  end
end
