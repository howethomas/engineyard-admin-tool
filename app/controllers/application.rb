# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f27b0292d4e6b6dece9f9ffcf9ee1d51'
  
  def ensure_logged_in
    unless initialize_logged_in_user
      flash[:error] = "You are not logged in!"
      redirect_to :controller => "welcome", :action => :login
    end
  end
  
  def ensure_admin
    user = initialize_logged_in_user
    unless user && user.admin?
      flash[:error] = "You must be an administrator to do that!"
      redirect_to :controller => "employees", :action => :configure 
    end
  end
  
  private
  
  def initialize_logged_in_user
    id_from_session = session[:logged_in_employee_id]
    @logged_in_user ||= Employee.find id_from_session if id_from_session
  end
  
end
