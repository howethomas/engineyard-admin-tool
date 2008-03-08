class CreateSettings < ActiveRecord::Migration
  def self.up
    drop_table :settings
    create_table :settings do |t|
      t.string :name
      t.string :type
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
