class AddPerformedAtColumnToActions < ActiveRecord::Migration
  def self.up
    add_column :actions, :performed_at, :datetime
  end

  def self.down
    remove_column :actions, :performed_at, :datetime
  end
end
