class AddAdminFlagToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :admin, :boolean
  end

  def self.down
    remove_column :employees, :admin
  end
end
