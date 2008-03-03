class Group < ActiveRecord::Base
  
  MAIN_ENGINEYARD_NUMBER = 1_866_518_9273
  
  validates_presence_of :name
  validates_format_of :name, :with => /^[\w\s_-]+$/
  validates_numericality_of :ivr_option
  validates_length_of :caller_id, :is => 11
  
  after_save    { Action.regen_queues_and_agents! }
  after_destroy { Action.regen_queues_and_agents! }
  
  has_many :employees, :through => :memberships
  
  has_many :memberships,     :dependent => :destroy
  has_one  :setting_manager, :dependent => :destroy
  
  after_create :create_setting_manager
  
  before_validation :ensure_caller_id_presence
  before_save :ensure_caller_id_presence
  
  alias members employees
  
  def initialize(*args, &block)
    super
    ensure_caller_id_presence
  end
  
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
  
  def ensure_caller_id_presence
    self.caller_id = MAIN_ENGINEYARD_NUMBER if caller_id.blank?
  end
  
end

