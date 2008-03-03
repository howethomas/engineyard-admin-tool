class AddCallerIdToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :caller_id, :string
  end

  def self.down
    remove_column :groups, :caller_id
  end
end
