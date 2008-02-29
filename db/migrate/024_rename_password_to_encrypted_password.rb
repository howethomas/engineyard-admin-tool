class RenamePasswordToEncryptedPassword < ActiveRecord::Migration
  def self.up
    rename_column :employees, :password, :encrypted_password
  end

  def self.down
    rename_column :employees, :encrypted_password, :password
  end
end
