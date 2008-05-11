class AddAvailabilityRules < ActiveRecord::Migration
  def self.up
    add_column :employees, :availability_rules, :text
  end

  def self.down
  end
end
