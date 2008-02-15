class RenamePerformedAtToPerformAt < ActiveRecord::Migration
  def self.up
    rename_column :actions, :performed_at, :perform_at
  end

  def self.down
    rename_column :actions, :perform_at, :performed_at
  end
end
