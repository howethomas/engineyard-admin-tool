class Group < ActiveRecord::Base
  
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w_-]+$/
  
  has_many :memberships
  has_many :employees, :through => :memberships
  
  alias members employees
  
  
  def available_employees
    employees.select(&:available?)
  end
  
  def generate_calls(server, customer_cookie)
    available_employees.each do |employee|
      server.call_agent \
        :phone_number    => employee.mobile_number,
        :customer_cookie => customer_cookie,
        :employee_id     => employee.id              
    end
  end
  
end
