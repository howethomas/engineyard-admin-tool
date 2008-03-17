class GroupSettingOverride < SettingOverride
  belongs_to :group, :foreign_key => "foreign_id"
  
  validates_presence_of :group
  
  validate :setting_must_not_be_global_only
  
  def setting_must_not_be_global_only
    errors.add(:setting, " is global only!") if setting && setting.global_only
  end
  
end