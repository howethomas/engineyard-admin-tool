class GroupSettingOverride < SettingOverride
  belongs_to :group, :foreign_key => "foreign_id"
  validates_presence_of :group
end