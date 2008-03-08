class RenameSettingTypeToKind < ActiveRecord::Migration
  
  # Had to fucking do this because the "type" method is reserved by AR.
  def self.up
    rename_column :settings, :type, :kind
  end

  def self.down
    add_column :settings, :kind, :type
  end
end
