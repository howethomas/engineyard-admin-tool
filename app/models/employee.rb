require 'md5'

class Employee < ActiveRecord::Base

  class << self
    
    def authenticate(email, password)
      employee = find_by_email email.downcase
      employee && employee.authenticated?(password) ? employee : false
    end
    
    def new_random_temp_password
      random_string + "_CHANGEME_" + random_string
    end
    
    def random_string(length=10)
      character_set = [0..9, 'a'..'z', 'A'..'Z'].map(&:to_a).flatten
      Array.new(length) { character_set[rand(character_set.size)] }.to_s
    end
    
    def password_with_salt(password, salt)
      MD5.md5("#{salt}-ey-#{password}--#{salt.reverse}").to_s
    end
    
    def next_available_extension
      all_extensions = Employee.find(:all).map(&:extension).map(&:to_i).sort
      search = all_extensions.inject do |previous, possibility|
        if possibility > previous + 1
          break previous + 1
        else
          possibility
        end
      end
      
      if search == all_extensions.last
        search + 1
      else
        search
      end
    end
    
    def blank_availability_rules
      Array.new(7) { [false] * 24 }
    end
    
    def nine_to_five_availability_rules
      blank_availability_rules.map do |day|
        day.fill(true, 9..17)
      end
    end
    
  end
  
  DEFAULT_CALL_TIMES = [[false] * 9 + [true] * 9 + [false] * 6] * 7
  
  attr_accessor :password
  
  serialize :availability_rules
  
  validates_numericality_of :extension, :voicemail_pin, :mobile_number
  validates_presence_of :name, :extension, :encrypted_password, :voicemail_pin
  validates_length_of :encrypted_password, :within => 4..40
  
  validates_numericality_of :extension
  validates_length_of :mobile_number, :minimum => 10, :allow_nil => true
  
  
  # The email address is used as a username
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[\w\._+%-]+@[\w\.-]+\.[a-zA-Z]{2,6}$/
  
  before_validation :encrypt_password, :downcase_email
  
  after_save    { Action.regen_queues_and_agents! }
  after_destroy { Action.regen_queues_and_agents! }
  
  
  has_many :memberships
  has_many :groups, :through => :memberships
  
  def initialize(*args, &block)
    super(*args, &block)
    initialize_availability_rules
  end
  
  def authenticated?(password)
    if self.salt
      self.encrypted_password == self.class.password_with_salt(password, self.salt)
    else
      # Temporary password
      self.encrypted_password == password
    end
  end
  
  def must_change_password?
    self.salt.blank?
  end
  
  def change_password_to(new_password)
    self.password = new_password
  end
  
  def create_password_reset_token
    returning self.class.random_string(100) do |token|
      update_attributes :password_reset_token => token
    end
  end
  
  def current_time_in_timezone
    TZInfo::Timezone.get(time_zone).utc_to_local(Time.now)
  end
  
  def available?
    current_time = current_time_in_timezone
    mobile_number && !on_vacation && (
      RAILS_ENV == 'production' ? availability_rules[current_time.wday][current_time.hour] : true
    )
  end
  
  def reset_password
    self.password_reset_token, self.salt = nil
    self.encrypted_password = Employee.new_random_temp_password
    self.save
  end
  
  private
  
  def availability_range(for_group)
    for_group.settings.call_receive_time_start.to_i..for_group.settings.call_receive_time_end.to_i
  end
  
  def downcase_email
    self.email &&= email.downcase
  end
  
  def encrypt_password
    if new_record?
      generate_temporary_password
    elsif self.password && self.salt.blank?
      self.salt      = self.class.random_string
      self.encrypted_password = self.class.password_with_salt(self.password, self.salt)
    elsif !self.salt.blank? && !self.password.blank?
      self.encrypted_password = self.class.password_with_salt(self.password, self.salt)
    end
  end

  def generate_temporary_password
    raise "Salt already set!" if self.salt
    self.encrypted_password = self.class.new_random_temp_password
  end

  def initialize_availability_rules
    self.availability_rules ||= Employee.nine_to_five_availability_rules
  end
  
end
