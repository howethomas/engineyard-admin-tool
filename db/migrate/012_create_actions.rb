class CreateActions < ActiveRecord::Migration
  def self.up
    create_table :actions do |t|
      t.references :server
      t.datetime :completed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :actions
  end
end
