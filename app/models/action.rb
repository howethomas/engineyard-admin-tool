class Action < ActiveRecord::Base

  class << self
    def regenerate_config_file(config_file_name)
      for server in Server.find(:all)
        create :name => 'regenerate_config_file', :message => config_file_name, :server => server
      end
    end
  end

  acts_as_paranoid :with => "completed_at"
  
  belongs_to :server
  validates_associated :server
  validates_presence_of :server
  
  validates_presence_of :name
  
  alias complete! destroy
  
end
