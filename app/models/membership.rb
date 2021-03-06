class Membership < ActiveRecord::Base
  
  belongs_to :employee
  belongs_to :group
  
  after_save do
    Action.regen_queues_and_agents!
    Action.regenerate_email_aliases!
  end
  after_destroy do
    Action.regen_queues_and_agents!
    Action.regenerate_email_aliases!
  end
  
  def self.destroy_memberships_for_employee(employee)
    destroy_all "employee_id = #{employee.id}"
  end
  
  # The +associations+ argument is a two dimensional array with
  # the second dimension having two indices: the employee id and
  # the group id. e.g. [[44,2][8,1],[19,4]]
  def self.redefine_membership_associations_with(associations)
    all_memberships = find :all
    
    valid_memberships = associations.map do |(employee_id, group_id)|
      membership = find_by_employee_id_and_group_id employee_id, group_id
      membership || Membership.create(:employee_id => employee_id, :group_id => group_id)
    end
    
    (all_memberships - valid_memberships).each &:destroy
    
    valid_memberships
  end
  
  private
  
end