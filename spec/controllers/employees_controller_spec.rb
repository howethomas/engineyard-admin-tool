require 'pp'
require File.dirname(__FILE__) + '/../spec_helper'

module EmployeeControllerTestHelper
  
  def ignore_authentication!
    controller.stub! :ensure_logged_in
  end

  def employee_without(*fields)
    returning @employee.clone do |employee|
      fields.each { |field| employee.delete field }
    end
  end
  
end

describe EmployeesController do

  include EmployeeControllerTestHelper

  before do
    ignore_authentication!
    @employee = {
      :mobile_number => "14155244444",
      :name => "Jay Phillips",
      :email => "Jicksta@Gmail.com",
      :extension => "252",
      :encrypted_password => "FOOBARQAZ"
    }
  end

  # it "should create an employee properly with all the required fields" do
  #   post :create, :employee => @employee
  #   response.should render_template('employees/next_steps')
  # end
  
  
end
