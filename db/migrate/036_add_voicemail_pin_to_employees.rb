class AddVoicemailPinToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :voicemail_pin, :integer
  end

  def self.down
    remove_column :employees, :voicemail_pin
  end
end
