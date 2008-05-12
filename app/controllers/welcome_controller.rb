class WelcomeController < ApplicationController
  
  before_filter :ensure_logged_in, :ensure_admin, :except => [:login, :forgot_password, :reset_password]
  
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
          set_logged_in_employee valid_employee
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
  
  def forgot_password
    email_address = params['username_of_forgotten_password']
    employee = Employee.find_by_email email_address.downcase
    if employee
      token = employee.create_password_reset_token
      PasswordMailer.deliver_password_reassignment(employee, token)
      flash[:notice] = "You have been sent an email with a password reset link!"
      redirect_to :action => "login"
    else
      flash[:error] = "This email address is not in our system!"
      redirect_to :action => "login"
    end
  end
  
  def reset_password
    token = params[:token]
    if employee = Employee.find_by_password_reset_token(token)
      set_logged_in_employee employee
      employee.reset_password
      employee.save
      redirect_to :action => "index"
    else
      render :text => "Invalid reset token!", :status => 404
    end
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
  
  private
  
  def set_logged_in_employee(employee)
    session[:logged_in_employee_id] = employee.id
  end
  
end
