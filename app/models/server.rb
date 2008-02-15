class Server < ActiveRecord::Base
  
  has_many :actions
  
  validates_uniqueness_of :name
  
end
