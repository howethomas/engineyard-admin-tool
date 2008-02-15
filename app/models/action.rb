class Action < ActiveRecord::Base
  
  acts_as_paranoid :with => "completed_at"
  
  belongs_to :server
  validates_associated :server
  
  alias complete! destroy
  
end
