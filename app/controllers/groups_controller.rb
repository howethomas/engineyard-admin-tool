class GroupsController < ApplicationController
  
  def editor
    if request.post?
      associations = params.select { |(key,value)| key =~ /^membership/ }
      Membership.redefine_membership_associations_with normalize_associations(associations)
    end
    
    @groups    = Group.find :all
    @employees = Employee.find(:all, :include => :groups).sort_by { |e| e.name[/\s*\S+$/].downcase }
    
    @full_size_container = true
  end
  
  def extension_manager
    @groups = Group.find :all# , :order => ''
    @employees = Employee.find :all
    
  end
  
  private
  
  def normalize_associations(associations)
    associations.map do |(key,value)|
      key.match(/^membership_(\d+)_(\d+)$/).captures.map &:to_i
    end
  end
  
end
