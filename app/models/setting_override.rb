class SettingOverride < ActiveRecord::Base
  
  # The foreign_id column can be either a Group id, an Employee id, or nil
  
  belongs_to :setting
  
  validates_presence_of :setting, :value
  validates_uniqueness_of :setting_id, :scope => :foreign_id

  def human_name
    self.setting.human_name
  end
  
end
