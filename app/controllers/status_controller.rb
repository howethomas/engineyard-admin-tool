class StatusController < ApplicationController
  before_filter :ensure_logged_in
  before_filter :ensure_admin
  
  def index
    case params[:id]
    when "linux"
      @results = "Date : #{%x[date]}"     
      @results += "Uptime : #{%x[uptime]}"     
      @results += "Running Proceses : #{%x[ps a]}"     
    when "asterisk"
      @results = "Asterisk : #{%x[asterisk -rx "core show version"]}"     
      @results += "Asterisk : #{%x[asterisk -rx "core show uptime"]}"  
      @results += "Asterisk : #{%x[tail -n1000 /var/log/asterisk/messages"]}"        
    when "agents"
      @results = "#{%x[asterisk -rx "show agents"]}"
    when "queues"
      @results = "#{%x[asterisk -rx "show queues"]}"
    when "channels"
      @results = "#{%x[asterisk -rx "core show channels"]}"
    when "pri"
      @results = "#{%x[asterisk -rx "pri show span 1"]}" 
      @results += "#{%x[asterisk -rx "pri show span 2"]}" 
    when "sip"
      @results = "#{%x[asterisk -rx "sip show peers"]}"
    when "voicemail"
      @results = "#{%x[asterisk -rx "voicemail show users for employees"]}"      
    end
    
    
    
    
    
    
  end
end  