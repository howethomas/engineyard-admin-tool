require File.dirname(__FILE__) + '/../spec_helper'

module EmployeeTestHelper
  
  def required_dummy_data
    {
      :name          => "Jay Phillips",
      :extension     => "123",
      :mobile_number => "1415524444",
      :email         => "#{rand}@Gmail.com"
    }
  end
end

describe Employee do
  
  include EmployeeTestHelper
  
  before(:each) do
    @employee = Employee.new
  end

  it "should be valid (with the dummy data)" do
    @employee.attributes = required_dummy_data
    @employee.should be_valid
  end
  
  it "should not be valid unless the email address is properly formatted" do
    @employee.attributes = required_dummy_data.merge :email => "thisdoesnothaveanatsign"
    @employee.should_not be_valid
  end
  
  it "should have an encrypted password after created" do
    @employee.save
    @employee.encrypted_password.should_not == nil
  end
  
  it "should have 'CHANGEME' in the password after created" do
    @employee.save
    @employee.encrypted_password.should include("CHANGEME")
  end
  
  it "should not have a password salt after created" do
    @employee.save
    @employee.salt.should == nil
  end

  
end
