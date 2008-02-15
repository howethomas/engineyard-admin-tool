class AddDeletedAt < ActiveRecord::Migration
  def self.up
    add_column :actions, :deleted_at, :datetime
  end

  def self.down
    remove_column :actions, :deleted_at
  end
end
