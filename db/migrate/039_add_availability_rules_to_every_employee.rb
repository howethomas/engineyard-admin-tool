class AddAvailabilityRulesToEveryEmployee < ActiveRecord::Migration
  
  def self.up
    Employee.find(:all).each do |employee|
      employee.availability_rules = Employee::DEFAULT_CALL_TIMES
      employee.save
    end
  end

  def self.down
  end
end
