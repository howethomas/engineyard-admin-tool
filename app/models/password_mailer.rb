class PasswordMailer < ActionMailer::Base
  
  ENGINEYARD_URL = "http://phones.engineyard.com"
  
  def new_password(employee)
    if email = employee.email
      recipients email
      from "noreply@engineyard.com"
      subject "EngineYard Phone System Account Created!"
      
      body :name => employee.name, :password => employee.encrypted_password
    end
  end

  def reassigned_password(employee)
    if email = employee.email
      recipients email
      from "noreply@engineyard.com"
      subject "EngineYard Phone System Password Reset!"
      
      body :password => employee.encrypted_password, :name => employee.name
    end
  end
  
end
