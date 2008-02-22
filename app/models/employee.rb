class Employee < ActiveRecord::Base
  
  # SHOULD BE FROM DATABASE!
  CALL_TIMES = 9..17 # 9am to 5pm
  
  validates_numericality_of :extension
  validates_presence_of :name, :extension
  
  has_many :memberships
  has_many :groups, :through => :memberships
  
  def available?
    mobile_number && !on_vacation && (RAILS_ENV == 'production' ? after_hours? : true)
  end
  
  private
  
  def after_hours?
    CALL_TIMES.include? current_time_in_timezone.hour
  end
  
  def current_time_in_timezone
    TZInfo::Timezone.get(time_zone).utc_to_local(Time.now)
  end
  
end