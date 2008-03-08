require File.dirname(__FILE__) + '/../spec_helper'

describe SettingOverride do
  
  it "should be an abstract class" do
    SettingOverride.should_not be_abstract_class
  end
  
end

describe GroupSettingOverride do
  
  fixtures :groups, :settings
  
  attr_reader :override
  before(:each) do
    @override = GroupSettingOverride.new
  end
  
  it "should not be valid without a group, setting, or human name" do
    override.should have(1).error_on(:setting)
    override.should have(1).error_on(:group)
  end
  
  it "should be valid with a group and setting" do
    override.group   = groups(:sales)
    override.setting = settings(:queue_timeout)
    override.value   = "foobar"
    override.should be_valid
  end
  
  it "should not be valid without a group" do
    override.setting = settings(:queue_timeout)
    override.should have(1).error_on(:group)
  end
  
end
