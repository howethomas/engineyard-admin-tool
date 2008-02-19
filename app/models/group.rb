class Group < ActiveRecord::Base
  
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w_-]+$/
  
  has_many :memberships
  has_many :employees, :through => :memberships
  
  has_one :setting_manager, :dependent => :destroy
  
  after_create :create_setting_manager
  
  alias members employees
  
  def available_employees
    employees.select(&:available?)
  end
  
  def generate_calls(server, customer_cookie)
    available_employees.each do |employee|
      puts "Creating call for agent #{employee}"
      
      mobile = employee.mobile_number
      mobile = mobile.chop if mobile.starts_with?('+')
      
      server.call_agent \
        :phone_number    => mobile,
        :customer_cookie => customer_cookie,
        :employee_id     => employee.id
    end
  end
  
  private
  
  def create_setting_manager
    self.setting_manager = SettingManager.create :group => self
  end
  
end
