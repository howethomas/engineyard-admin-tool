class AddHumanNameToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :human_name, :string
  end

  def self.down
    remove_column :settings, :human_name
  end
end
