class Group < ActiveRecord::Base
  
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w\s_-]+$/
  validates_numericality_of :ivr_option
  
  after_save    { Action.regen_queues_and_agents! }
  after_destroy { Action.regen_queues_and_agents! }
  
  has_many :employees, :through => :memberships
  
  has_many :memberships,     :dependent => :destroy
  has_one  :setting_manager, :dependent => :destroy
  
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
        :employee_id     => employee.id,
        :group_id        => self.id
    end
  end
  
  private
  
  def create_setting_manager
    self.setting_manager = SettingManager.create :group => self
  end
  
end
