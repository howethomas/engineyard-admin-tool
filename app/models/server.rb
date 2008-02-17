class Server < ActiveRecord::Base
  
  has_many :actions
  
  validates_uniqueness_of :name
  
  def call_agent(options)
    actions.create :name    => "call_agent",
                   :message => options.to_yaml
  end
  
end
