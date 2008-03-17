class Setting < ActiveRecord::Base
  
  VALID_SETTING_TYPES = %w[boolean string integer]
  
  attr_accessor :initial_value
  
  validates_presence_of :initial_value, :on => :create
  validates_presence_of :name, :kind, :human_name
  validates_uniqueness_of :name
  
  validates_inclusion_of :kind, :in => VALID_SETTING_TYPES

  has_one :global_setting_override
  has_many :group_setting_overrides

  after_create :create_global_override
  
  def create_global_override(value=initial_value)
    GlobalSettingOverride.create :setting => self, :enabled => true, :value => value
  end
  
end