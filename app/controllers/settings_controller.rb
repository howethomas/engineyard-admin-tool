class SettingsController < ApplicationController
  
  before_filter :ensure_logged_in
  
  GLOBAL_SETTING     = /^global_(\d+)$/
  INDIVIDUAL_SETTING = /^group_(\d+)_(\d+)$/
  
  def editor
    
    @save_errors = []
    
    if request.post?
      global_params  = *params.select { |(key, value)| key =~ GLOBAL_SETTING }
      group_params   = *params.select { |(key, value)| key =~ INDIVIDUAL_SETTING }
      enabled_params = params.select { |(key, value)| key.starts_with? 'enabled' } || []
      enabled_params.map! { |(key, value)| key[/^enabled_(.+)$/,1] }
      
      
      
      global_params.each do |(key, value)|
        setting_id = key[GLOBAL_SETTING,1]
        override   = GlobalSettingOverride.find_or_create_by_setting_id(setting_id)
        override.value = value
        unless override.save
          @save_errors << {:id => key, :errors => override.errors.full_messages}
        end
      end
      
      group_params.each do |(key, value)|
        group_id, setting_id = key.match(INDIVIDUAL_SETTING).captures
        group = Group.find group_id
        override = group.group_setting_overrides.find_or_create_by_setting_id(setting_id)
        override.value = value
        override.enabled = enabled_params.include? key
        unless override.save
          @save_errors << {:id => key, :errors => override.errors.full_messages}
        end
      end
      
      if @save_errors.empty?
        flash.now[:notice] = "Settings updated"
      else
        # raise @save_errors.inspect
        flash.now[:error] = "Error saving all data! Review and correct the errors below."
      end
    end
    
    @settings = Setting.find(:all)
    @groups = Group.find(:all, :include => :group_setting_overrides)
  end

end
