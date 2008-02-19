class SettingManager < ActiveRecord::Base
  
  class << self
    def global
      find :first, :conditions => "group_id is null"
    end
    
    def [](key)
      global.settings[key]
    end

    def []=(key, value)
      global.settings[key] = value
    end
  end
  
  belongs_to :group
  
  has_many :settings do
    
    def [](key)
      self.find_by_key key
    end
    
    def []=(key, value)
      self.find_or_create_by_key(key).update_attributes :value => value
    end
    
  end
  
end
