# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    session[:email] && session[:password]
  end
  
  def logout
    link_to "Logout", :controller => "welcome", :action => "logout"
  end
  
end
