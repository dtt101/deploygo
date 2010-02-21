class HomeController < ApplicationController
  
  before_filter :get_user
  
  def index
    # renders index.html.erb
  end 
  
  def about
    # renders about page
  end
  
  def contact
    # renders contact page
  end
  
  def support
    # render support page - faqs
  end
  
  def plans
    # render plans page
    @newuser = User.new
    @neworg = Organisation.new
  end
  
  def register
    # TODO:
    # send email with thank you and username, URL
    @newuser = User.new(params[:newuser])
    @neworg = Organisation.new(params[:neworg])
    @neworg.administrator = false
    @newuser.read_only = false
    Organisation.transaction do 
      @neworg.save! 
      @newuser.organisation = @neworg 
      @newuser.save!
      login_user(@newuser)
      redirect_to(:controller => "time", :action => "index")
    end
    rescue ActiveRecord::RecordInvalid => e 
    	# force checking of errors
      @newuser.valid?
      @neworg.valid?
      flash.now[:warning] = "All fields are required, and the passwords must be the same"
      render :action => :plans
  end
  
  def login
    @bodyid = "login"
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
    @bodyid = "login"
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
        # End test
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
