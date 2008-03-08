class AddValueToSettingOverride < ActiveRecord::Migration
  def self.up
    add_column :setting_overrides, :value, :string
  end

  def self.down
    remove_column :setting_overrides, :value
  end
end
