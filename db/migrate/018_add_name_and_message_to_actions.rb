class AddNameAndMessageToActions < ActiveRecord::Migration
  def self.up
    add_column :actions, :name, :string
    add_column :actions, :message, :string
  end

  def self.down
    remove_column :actions, :name
    remove_column :actions, :message
  end
end
