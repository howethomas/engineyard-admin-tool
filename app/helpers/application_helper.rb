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
    return phone_number unless phone_number.length == 11
    intl, npa, nxx, xxxx = phone_number.match(/^(\d)(\d{3})(\d{3})(\d{4})$/).captures
    "#{intl} (#{npa}) #{nxx}-#{xxxx}"
  end
  
end
