class Server < ActiveRecord::Base
  
  has_many :actions
  
  validates_uniqueness_of :name
  
  def trigger_agent_calls_for(group_name)
    group = Group.find_by_name group_name
    group.employees.each do |employee|
      call_agent_at employee.mobile_number if employee.available?
    end
  end
  
  def call_agent_at(phone_number)
    actions.create :name => "call_agent",
                   :message => phone_number
  end
  
end
