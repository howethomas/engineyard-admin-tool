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
    override.value   = "123"
    override.valid?
    y override.errors
    override.should be_valid
  end
  
  it "should not be valid without a group" do
    override.setting = settings(:queue_timeout)
    override.should have(1).error_on(:group)
  end
  
  it "should not allow a non-numerical String in an 'integer' override" do
    override.group   = groups(:sales)
    override.setting = settings(:queue_timeout) # Integer override
    override.value   = "foobar"
    override.should have(1).error_on(:value)
  end
  
  it "should not allow a non-boolean String in an 'boolean' override" do
    override.group   = groups(:sales)
    override.setting = settings(:allow_star_to_hangup) # Boolean override
    override.value   = "thisisnotfalse"
    override.should have(1).error_on(:value)
  end
  
  it "should allow just about anything in an override for a 'string'" do
    override.group   = groups(:sales)
    override.setting = settings(:string_setting) # Boolean override
    override.value   = "12321 true askdfaskm"
    override.should have(0).errors_on(:value)
  end
  
end
