class AddFlagForGlobalOnlySettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :global_only, :boolean
  end

  def self.down
    remove_column :settings, :global_only
  end
end
