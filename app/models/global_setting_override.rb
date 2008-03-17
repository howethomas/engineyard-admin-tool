class GlobalSettingOverride < SettingOverride
  
  before_save :ensure_enabled
  
  def ensure_enabled
    self.enabled = true
  end
end