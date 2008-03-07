# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def logged_in?
    session[:email] && session[:password]
  end
  
  def logout
    link_to "Logout", :controller => "welcome", :action => "logout"
  end
  
  def format_phone_number(phone_number)
    phone_number = phone_number.to_s
    match = phone_number.match /^1(\d{3})(\d{3})(\d{4})$/
    return phone_number unless match
    npa, nxx, xxxx = match.captures
    "1 (#{npa}) #{nxx}-#{xxxx}"
  end
  
end
