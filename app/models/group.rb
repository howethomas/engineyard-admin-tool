class Group < ActiveRecord::Base
  
  MAIN_ENGINEYARD_NUMBER = 1_866_518_9273
  
  validates_presence_of :name
  validates_numericality_of :ivr_option
  validates_length_of :caller_id, :is => 11
  
  validates_format_of :name,  :with => /^[\w\s_-]+$/
  
  after_save    { Action.regen_queues_and_agents! }
  after_destroy { Action.regen_queues_and_agents! }
  
  has_many :employees, :through => :memberships
  
  has_many :memberships,             :dependent => :destroy
  has_many :group_setting_overrides, :dependent => :destroy, :foreign_key => "foreign_id"
  
  before_validation :ensure_caller_id_presence
  before_save :ensure_caller_id_presence
  
  alias members employees
  
  def initialize(*args, &block)
    super
    ensure_caller_id_presence
    settings              # Make sure we have the default settings.... set.
  end
  
  def settings
    @setting_accessor ||= GroupSettingAccessor.new(self)
  end
  
  def available_employees
    employees.select(&:available?)
  end
  
  def generate_calls(server, options={})
    ahn_log "Inside generate_calls!" if respond_to?(:ahn_log)
    exclusions = Array(options[:exclude]).map(&:to_s)
    puts "Not calling these guys:"
    p exclusions
    employees_to_call = available_employees.reject { |employee| exclusions.include?(employee.id.to_s) }
    puts "These are the guys I'm going to call: #{employees_to_call.inspect}"
    
    employees_to_call.each do |employee|
      puts "Creating call for agent #{employee}"
      
      mobile = employee.mobile_number
      
      server.call_agent \
        :phone_number => mobile,
        :employee_id  => employee.id,
        :group_id     => self.id
    end
  end
  
  def empty?
    self.employees.count.zero?
  end
  
  private
  
  def ensure_caller_id_presence
    self.caller_id = MAIN_ENGINEYARD_NUMBER if caller_id.blank?
  end
  
  class GroupSettingAccessor
    def initialize(group_instance)
      @group_instance = group_instance
    end
    
    def method_missing(name, *args, &block)
      name = name.to_s
      if name.ends_with? '='
        setting = Setting.find_by_name name.chop!
        super unless setting
        new_override = @group_instance.group_setting_overrides.find_or_create_by_setting_id(setting.id)
        new_override.value = args.first
        new_override.enable!
        new_override.save
      else
        setting = Setting.find_by_name name
        super unless setting
        query = @group_instance.group_setting_overrides.find_by_setting_id(setting.id)
        value = query.value
        (value && !value.blank?) ? value : setting.global_setting_override.value
      end
    end
  end
  
end

