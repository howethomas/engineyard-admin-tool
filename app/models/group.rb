class Group < ActiveRecord::Base
  
  validates_presence_of :name
  validates_format_of :names, :with => /^[\w_-]+$/
  
  has_many :memberships
  has_many :employees, :through => :memberships
  
  alias_attribute :members, :employees
  
end
