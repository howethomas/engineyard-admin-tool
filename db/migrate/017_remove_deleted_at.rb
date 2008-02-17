class RemoveDeletedAt < ActiveRecord::Migration
  def self.up
    remove_column :actions, :deleted_at
  end

  def self.down
    add_column :actions, :deleted_at, :datetime
  end
end
