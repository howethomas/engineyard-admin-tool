class SettingsController < ApplicationController

  before_filter :ensure_logged_in
  
  GLOBAL_SETTING     = /^global_(\d+)$/
  INDIVIDUAL_SETTING = /^group_(\d+)_(\d+)$/
  
  def editor
    
    if request.post?
      global_params = *params.select { |(key, value)| key =~ GLOBAL_SETTING }
      group_params  = *params.select { |(key, value)| key =~ INDIVIDUAL_SETTING }
      
      global_setting_manager = SettingManager.global
      global_params.each do |(key, value)|
        Setting.find(key[GLOBAL_SETTING,1]).update_attributes :value => value
      end
      
      group_params.each do |(key, value)|
        group_id, setting_id = key.match(INDIVIDUAL_SETTING).captures
        Group.find(group_id).setting_manager.settings.find(setting_id).update_attributes :value => value
      end
      
      flash[:notice] = "Settings updated"
    end
    
    @global_settings = SettingManager.global.settings
    @groups = Group.find(:all, :include => :setting_manager)
  end
  
  
  private
  
end
