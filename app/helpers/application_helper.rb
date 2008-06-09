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
  
  def humanize_hour(hour)
    if hour == 0
      "12am"
    elsif hour < 12
      "#{hour}am"
    elsif hour == 12
      "12pm"
    else
      "#{hour - 12}pm"
    end
  end
  
  def on_day(day) 
    update_page do |page|
      for hour in 0..23 
        page["available_#{day}_#{hour}"].checked = true
      end
    end 
  end 

  def on_hour(hour) 
    update_page do |page|
      for day in 0..6
        page["available_#{day}_#{hour}"].checked = true
      end
    end 
  end 

  def off_day(day) 
    update_page do |page|
      for hour in 0..23 
        page["available_#{day}_#{hour}"].checked = false
      end
    end 
  end 
  
  def off_hour(hour) 
    update_page do |page|
      for day in 0..6
        page["available_#{day}_#{hour}"].checked = false
      end
    end 
  end 
  
end
