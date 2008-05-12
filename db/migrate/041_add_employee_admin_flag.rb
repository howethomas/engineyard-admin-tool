class AddEmployeeAdminFlag < ActiveRecord::Migration
  def self.up
    add_column :employees, :admin, :boolean
  end

  def self.down
  end
end
