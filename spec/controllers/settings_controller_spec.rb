require File.dirname(__FILE__) + '/../spec_helper'
# setting name, group name, enabled, value. returns two pairs: one for enabled and one with the value

class Override
  
  def initialize
    @enabled = true
    yield self if block_given?
  end
  
  def setting(name)
    @setting = Setting.find_by_name name
  end
  
  def setting_id
    @setting.id
  end
  
  def group(name)
    @group = Group.find_by_name name
  end
  
  def group_id
    @group.id
  end
  
  def value(new_value)
    @value = new_value
  end
  
  def +(other)
    coerce.merge other.coerce
  end
  
  def coerce
    if @group
      id = "group_#{@group.id}_#{@setting.id}"
      {id => @value, "enabled_#{id}" => @enabled }
    else
      id = "global_#{@setting.id}"
      {id => @value, "enabled_#{id}" => @enabled}
    end
  end
  
end

describe SettingsController do

  it "should not save an empty and disabled setting override to the database"
  
  it "should enabled overrides to the database"# do
  #   one = Override.new do |override|
  #     override.setting :allow_star_to_hangup
  #     override.group   "Sales"
  #     override.value   true
  #   end
  #   
  #   # Global override
  #   two = Override.new do |override|
  #     override.setting :queue_timeout
  #     override.value   "Foobar"
  #   end
  #   
  #   post :create, one + two
  #   
  #   GlobalSettingOverride.should receive(:find).with(one.setting_id)
  # end
  
end
