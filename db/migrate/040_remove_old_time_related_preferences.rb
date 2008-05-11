class RemoveOldTimeRelatedPreferences < ActiveRecord::Migration
  def self.up
    %w'call_receive_time_end call_receive_time_start'.each do |setting_name|
      setting = Setting.find_by_name(setting_name)
      setting.global_setting_override.destroy
      setting.group_setting_overrides.each(&:destroy)
      setting.destroy
    end
  end

  def self.down
  end
end
