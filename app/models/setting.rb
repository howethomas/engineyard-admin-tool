class Setting < ActiveRecord::Base
  
  belongs_to :setting_manager
  
  validates_presence_of :key
  
end
