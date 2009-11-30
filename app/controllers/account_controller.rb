class AccountController < ApplicationController
  
  before_filter :authorize, :get_organisation, :get_user
  
  def index
  end
  
  def update
    # make sure administrator value not in params
    if params[:organisation][:administrator]
      params[:organisation].delete('administrator')
    end
    respond_to do |format|
      if @organisation.update_attributes(params[:organisation])
        flash[:notice] = 'Your account was successfully updated.'
        format.html { redirect_to :action => "index" }
      else
        flash.now[:notice] = 'There was a problem updating your account.'
        format.html { render :action => "index" }
      end
    end
  end

end
