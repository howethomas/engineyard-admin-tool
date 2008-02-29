# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f27b0292d4e6b6dece9f9ffcf9ee1d51'
  
  def ensure_logged_in
    id_from_session = session[:logged_in_employee_id]
    if id_from_session
      @logged_in_user = Employee.find id_from_session
      redirect_to :controller => "welcome", :action => :login unless @logged_in_user
    else
      flash[:error] = "You are not logged in!"
      redirect_to :controller => "welcome", :action => :login unless @logged_in_user
    end
  end
  
end
