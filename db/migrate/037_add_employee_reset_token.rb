class AddEmployeeResetToken < ActiveRecord::Migration
  def self.up
    add_column :employees, :password_reset_token, :string
  end

  def self.down
  end
end
