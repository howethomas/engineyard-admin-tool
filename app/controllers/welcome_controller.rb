class WelcomeController < ApplicationController
  
  before_filter :ensure_logged_in, :except => :login
  
  def index
  end
  
  def login
    
  end
  
end
