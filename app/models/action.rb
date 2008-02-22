class Action < ActiveRecord::Base

  class << self
    def regenerate_config_file(*config_files)
      config_files.each do |config_file_name|
        Server.find(:all).each do |server|
          create :name => 'regenerate_config_file', :message => config_file_name, :server => server
        end
      end
    end
    
    def regen_queues_and_agents!
      regenerate_config_file 'agents', 'queues'
    end
    
  end

  acts_as_paranoid :with => "completed_at"
  
  belongs_to :server
  validates_associated :server
  validates_presence_of :server
  
  validates_presence_of :name
  
  alias complete! destroy
  
end
