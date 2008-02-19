class RenameSettingManagerColumnServerIdToGroupId < ActiveRecord::Migration
  def self.up
    remove_column :setting_managers, :server_id
    add_column :setting_managers, :group_id, :integer
  end

  def self.down
    remove_column :setting_managers, :group_id
    add_column :setting_managers, :server_id, :integer
  end
end
