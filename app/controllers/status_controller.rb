class StatusController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :ensure_admin
  
  def index
  end
  
  def application
  end

  def user
  end

  def asterisk
  end

  def adhearsion
  end

  def system
    @processes = %x[ps]
  end

  def calls
  end
end
