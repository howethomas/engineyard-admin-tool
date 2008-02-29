require 'md5'

class Employee < ActiveRecord::Base

  class << self
    
    def authenticate(email, password)
      employee = find_by_email email.downcase
      employee && employee.authenticated?(password)
    end
    
    def new_random_temp_password
      random_string + "_CHANGEME_" + random_string
    end
    
    def random_string(length=10)
      Array.new(length) do
        [0..9, 'a'..'z', 'A'..'Z'].map(&:to_a).flatten[rand(10 + 26 + 26)]
      end.to_s
    end
    
    def password_with_salt(password, salt)
      MD5.md5("#{salt}-ey-#{password}--#{salt.reverse}").to_s
    end
    
  end
  
  # SHOULD BE FROM DATABASE!
  CALL_TIMES = 9..17 # 9am to 5pm
  
  attr_accessor :password
  
  validates_numericality_of :extension
  validates_presence_of :name, :extension, :encrypted_password
  validates_length_of :password, :within => 4..40
  
  validates_numericality_of :extension
  validates_length_of :mobile_number, :minimum => 10
  
  # The email address is used as a username
  validates_presence_of :email
  validates_uniqueness_of :email
  
  after_create :generate_temporary_password
  before_save :encrypt_password, :downcase_email
  
  
  after_save    { Action.regen_queues_and_agents! }
  after_destroy { Action.regen_queues_and_agents! }
  
  
  has_many :memberships
  has_many :groups, :through => :memberships
  
  def available?
    mobile_number && !on_vacation && (RAILS_ENV == 'production' ? after_hours? : true)
  end
  
  def authenticated?(password)
    if self.salt
      self.encrypted_password == self.class.password_with_salt(password, self.salt)
    else
      # Temporary password
      self.encrypted_password == password
    end
  end
  
  private
  
  def downcase_email
    self.email &&= email.downcase
  end
  
  def encrypt_password
    if new_record?
      generate_temporary_password
    elsif self.salt && self.password
      self.salt      = self.class.random_string
      self.encrypted_password = self.class.password_with_salt(self.password, self.salt)
    end
  end

  def after_hours?
    CALL_TIMES.include? current_time_in_timezone.hour
  end
  
  def current_time_in_timezone
    TZInfo::Timezone.get(time_zone).utc_to_local(Time.now)
  end
  
  def generate_temporary_password
    raise "Salt already set!" if self.salt
    update_attributes :encrypted_password => self.class.new_random_temp_password
  end
  
end
