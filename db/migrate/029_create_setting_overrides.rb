class CreateSettingOverrides < ActiveRecord::Migration
  def self.up
    create_table :setting_overrides do |t|
      t.integer :setting_id
      t.string :type
      t.integer :foreign_id
      t.boolean :enabled

      t.timestamps
    end
  end

  def self.down
    drop_table :setting_overrides
  end
end
