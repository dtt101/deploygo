class HomeController < ApplicationController
  
  def index
    # TODO - create new homepage template
    # TODO - style flash notifications
    # TODO - make sure login flow works correctly - so you can login on homepage and login
    # TODO - apply template css to other public pages
    # TODO - strip unecessary HTML from application css
    # TODO - apply new feel to applications
  end 
  
  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        login_user(user)
        redirect_to(:controller => "time", :action => "index")
      else
        flash.now[:warning] = "Invalid username/password combination"
      end
    end
  end

  def logout
    reset_session
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end

  def forgotten
    user = User.find_by_email(params[:email])
    if request.post?
      user = User.find_by_email(params[:email])
      if user
        user.reset_password_code_until = 1.day.from_now
        user.reset_password_code =  Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
        user.save!
        UserMailer.deliver_forgot_password(user)
        # Uncomment to test
        #email = UserMailer.create_forgot_password(user)
        #render(:text => "<pre>" + email.encoded + "</pre>")
        flash.now[:notice] = "Your password reset instructions have been emailed to #{user.email}."
      else
        flash.now[:warning] = "Sorry, we can't find that email address in our system. Please try again."
      end
    end
  end
  
  def reset_password
    user = User.find_by_reset_password_code(params[:id])
    if user && user.reset_password_code_until && Time.now < user.reset_password_code_until 
      login_user(user)
      flash[:notice] = 'Please reset your password'
      redirect_to(:controller => 'users', :action => 'edit', :id => user.id)
    else
      # kick them out
      authorize()
    end
  end
 
  def thanks
    # landing page for people signing up to newsletter via campaign monitor
  end
  
  def tour
    # tour page showing features and screenshots
    @bodyid = "tour"
  end
 
  private
  
  def login_user(user)
    # creates session variables when user is logged in
    session[:organisation_id] = user.organisation.id
    session[:user_id] = user.id
    session[:administrator] = user.organisation.administrator
    session[:readonlyuser] = user.read_only
  end
end
