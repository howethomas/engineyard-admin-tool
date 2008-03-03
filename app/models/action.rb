class Action < ActiveRecord::Base

  class << self
    def regenerate_config_file(*config_files)
      config_files.each do |config_file_name|
        with_each_server do |server|
          create :name => 'regenerate_config_file', :message => config_file_name, :server => server
        end
      end
    end
    
    def regen_queues_and_agents!
      regenerate_config_file 'agents', 'queues'
    end
    
    def introduce(source, destination)
      create :name => "introduce", :message => "#{source}|#{destination}", :server => introduction_server
    end
    
    private
    
    def introduction_server
      # This is too brittle! It should just enqueue a message and the first server to get it performs the
      # origination.
      Server.find :first # Should be PBX-1
    end
    
    def with_each_server(&block)
      Server.find(:all).each(&block)
    end
    
  end

  acts_as_paranoid :with => "completed_at"
  
  belongs_to :server
  validates_associated :server
  validates_presence_of :server
  
  validates_presence_of :name
  
  alias complete! destroy
  
end
