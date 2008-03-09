class SettingOverride < ActiveRecord::Base
  
  # The foreign_id column can be either a Group id, an Employee id, or nil
  
  belongs_to :setting
  
  validates_presence_of :setting
  validates_uniqueness_of :setting_id, :scope => :foreign_id

  validate :value_must_match_setting_kind
  
  def human_name
    self.setting.human_name
  end
  
  private
  
  def value_must_match_setting_kind
    if setting && !value.blank? # Let's let the other validation catch this...
      case setting.kind
        when 'integer'
          errors.add(:value, "#{value.inspect} is not numerical!") unless value.to_s =~ /^\d+$/
        when 'boolean'
          errors.add(:value, "Value #{value.inspect} is not boolean!") unless [true, false, 'true', 'false'].include? value
      end
    end
  end
end
