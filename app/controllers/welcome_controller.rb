class WelcomeController < ApplicationController
  
  before_filter :ensure_logged_in, :except => :login
  
  def index
  end
  
  def login
    if request.post?
      email, password = params["email"], params["password"]
      if email.blank? && password.blank?
        flash[:error] = "Fill in the blanks!"
      elsif email.blank?
        flash[:error] = "You must supply an email address!"
      elsif password.blank?
        flash[:error] = "You must supply a password!"
      else
        # Both an email and a password were given!
        valid_employee = Employee.authenticate(email, password)
        if valid_employee
          session[:logged_in_employee_id] = valid_employee.id
          redirect_to :action => "index"
        else
          flash[:error] = "Incorrect email address or password!"
          redirect_to :action => "login"
        end
      end
    end
  end
  
  def logout
    session[:logged_in_employee_id] = nil
    redirect_to :action => "login"
  end
  
  def change_password
    if request.post?
      one, two = params["password_one"], params["password_two"]
      if !one.blank? && !two.blank? && one == two
        @logged_in_user.change_password_to one
        if @logged_in_user.save
          flash[:notice] = "Password successfully changed. Don't forget it!"
        else
          flash[:error] = "There was an error changing your password!"
        end
      else
        flash[:error] = "Passwords do not match or were not supplied!"
      end
    end
    redirect_to :back
  end
  
end
