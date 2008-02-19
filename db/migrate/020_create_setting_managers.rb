class CreateSettingManagers < ActiveRecord::Migration
  def self.up
    create_table :setting_managers do |t|
      t.references :server
      t.timestamps
    end
  end

  def self.down
    drop_table :setting_managers
  end
end
