class ChangeActionMessageFromStringToText < ActiveRecord::Migration
  def self.up
    remove_column :actions, :message
    add_column :actions, :message, :text
  end

  def self.down
    remove_column :actions, :message
    add_column :actions, :message, :string
  end
end
