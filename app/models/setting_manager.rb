class SettingManager < ActiveRecord::Base
  
  class << self
    def for_system
      find :first, :conditions => "server_id is null"
    end
    
    def [](key)
      for_system.settings.find_by_key key
    end

    def []=(key, value)
      search = for_system.settings.find_or_create_by_key key
      search.key = value
      search.save
      value
    end
  end
  
  belongs_to :server
  
  has_many :settings do
    
    def [](key)
      self.find_by_key key
    end
    
    def []=(key, value)
      self.find_or_create_by_key(key).update_attributes :value => value
    end
    
  end
  
  def for_system?
    self.server.nil?
  end
  
end
