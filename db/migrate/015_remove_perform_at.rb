class RemovePerformAt < ActiveRecord::Migration
  def self.up
    remove_column :actions, :perform_at
  end

  def self.down
    add_column :actions, :perform_at, :datetime
  end
end
