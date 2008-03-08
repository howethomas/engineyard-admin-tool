class Setting < ActiveRecord::Base
  
  VALID_SETTING_TYPES = %w[boolean string integer]
  
  validates_presence_of :name, :kind, :human_name
  validates_uniqueness_of :name
  
  validates_inclusion_of :kind, :in => VALID_SETTING_TYPES, :except => "a"
  
end
