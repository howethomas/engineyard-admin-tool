require File.dirname(__FILE__) + '/../spec_helper'

describe Setting do
  
  attr_reader :setting
  before(:each) do
    @setting = Setting.new
  end

  it "should be valid" do
    setting.should_not be_valid
  end
  
  it "should be valid with a name, kind, human name, and initial value when creating" do
    setting.attributes = {:name => "blargh", :kind => 'string', :human_name => "Hooman", :initial_value => "value", }
    setting.valid?
    setting.should be_valid
  end

  it "should blow up when two settings exist with the same name" do
    one = Setting.new :name => "foobar", :kind => "string", :human_name => "bargh"
    two = Setting.new :name => "foobar", :kind => "string", :human_name => "bleh" 
    
    one.save
    two.save
    
    one.should have(0).errors
    two.should have(1).error_on(:name)
  end
  
end

describe Setting, 'kinds' do
  
  attr_reader :setting
  before do
    @setting = Setting.new :name => "does not matter", :human_name => "does not matter"
  end
  
  it "should allow an :integer kind" do
    setting.kind = 'integer'
    setting.initial_value = 123
    setting.should be_valid
  end
  
  it "should allow a :boolean kind" do
    setting.kind = 'boolean'
    setting.initial_value = true
    setting.should be_valid
  end
  
  it "should allow a :string kind" do
    setting.kind = 'string'
    setting.initial_value = "jay phillips"
    setting.should be_valid
  end
  
  it "should blow up with a unrecognized kind" do
    setting.kind = 'ijustmadethisup'
    setting.initial_value = 'ijustmadethisup'
    setting.should_not be_valid
  end
  
end
