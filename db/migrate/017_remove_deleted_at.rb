class RemoveDeletedAt < ActiveRecord::Migration
  def self.up
    remove_column :deleted_at
  end

  def self.down
    add_column :deleted_at, :datetime
  end
end
