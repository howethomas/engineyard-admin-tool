class RemoveGroupEmailAddress < ActiveRecord::Migration
  def self.up
    remove_column :groups, :email
  end

  def self.down
    add_column :groups, :email, :string
  end
end
