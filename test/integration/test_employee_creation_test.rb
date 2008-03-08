require "#{File.dirname(__FILE__)}/../test_helper"

class CheckEmployeeCreationTest < ActionController::IntegrationTest

  attr_reader :employee
  def setup
    @employee = {
      :mobile_number => "14155244444",
      :name => "Jay Phillips",
      :email => "Jicksta@Gmail.com",
      :extension => "252",
      :encrypted_password => "FOOBARQAZ"
    }
  end

  def test_assignment_of_employee
    ignore_authentication!
    post 'employees/create', :employee => {
                                            :mobile_number => "14155244444",
                                            :name          => "Jay Phillips",
                                            :extension     => "300",
                                            :email         => "#{rand}@Gmail.com"
                                          }
    
    assert response.redirect?
    follow_redirect!
    assert_response :success
    
    assert_template "employees/next_steps"
    assert response.body.include?("CHANGEME")
  end
  
  def test_failed_employee_creation_has_correct_fields_preserved
    modified_employee = @employee.merge :email => "ThisDoesNotHaveAnAtSign"
    post 'employees/create', :employee => modified_employee
    puts request.public_methods.sort - request.class.superclass.instance_methods
    assert_select '#employee_email', employee[:name]
  end
  
  private
  
  def ignore_authentication!
    EmployeesController.any_instance.stubs :ensure_logged_in
  end
  
end
