class AddEmailToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :email, :string
  end

  def self.down
    remove_column :groups, :email
  end
end
