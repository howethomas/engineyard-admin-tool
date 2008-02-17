class Action < ActiveRecord::Base

  acts_as_paranoid :with => "completed_at"
  
  belongs_to :server
  validates_associated :server
  validates_presence_of :server
  
  validates_presence_of :name
  
  alias complete! destroy
  
end
