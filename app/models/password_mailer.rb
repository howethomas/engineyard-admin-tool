class PasswordMailer < ActionMailer::Base
  
  default_url_options[:host] = ENV["RAILS_ENV"] == "development" ? "localhost:3000" : "pbx.engineyard.com"
  
  def new_password(employee)
    if email = employee.email
      recipients email
      from "pbx@engineyard.com"
      subject "Engine Yard Phone System Account Created!"
      
      body :name => employee.name, :password => employee.encrypted_password
    end
  end

  def password_reassignment(employee, reset_token)
    if email = employee.email
      recipients email
      from "pbx@engineyard.com"
      subject "Engine Yard Phone System Password Reset!"
      
      body :token => reset_token, :name => employee.name
    end
  end
  
end
