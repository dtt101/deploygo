# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_404  
  rescue_from RuntimeError, :with => :render_500

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '87cf359771d8d91730245a5161d60470'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def get_organisation
    # finds currently logged in organisation from session - sets @organisation
    # get current organisation
    @organisation = Organisation.find(session[:organisation_id])
  end
  
  def get_user
    # find currently logged in user
    @user = User.find(session[:user_id])
  end    
  
  # authorize as logged in user
  def authorize
    redirect_user = false
    if (session[:user_id] == nil)
      redirect_user = true
    elsif (User.find_by_id(session[:user_id]) == nil)
      redirect_user = true
    end
    if redirect_user
      redirect_to(:controller => "home", :action => "login")
    end
  end  
  
  # authorize as admin - sends home if not an admin
  def authorize_as_admin
    unless session[:administrator]
      redirect_to(:controller => "home", :action => "index")
    end
  end
  
  # if user is read only kicks back to planner
  def authorize_as_readwrite
    if session[:readonlyuser]
      redirect_to(:controller => "time", :action => "index")      
    end
  end
  
  private 
  
  # custom 404 page
  def render_404  
    render :template => "shared/error_404", :layout => 'home', :status => :not_found  
  end  

  # custom 500 page
  def render_500
    render :template => "shared/error_500", :layout => 'home', :status => :internal_server_error  
  end
end
