#
# Warning!!!  This controller does not control the typical "active_record" model.  
# This controller works on a file system managed by Asterisk, and has to recreate
# its data every time
#
class VoicemailsController < ApplicationController
    before_filter :ensure_logged_in
    before_filter :ensure_admin, :except => :configure

    # GET /employees
    # GET /employees.xml
    def index
      extension = Employee.find(session[:logged_in_employee_id]).extension      
      @voicemails = get_voicemails(extension, :all)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @voicemails }
      end
    end
    
    def play
      send_file params[:sound_file]    
    end

    # GET /employees/1
    # GET /employees/1.xml
    def show
      @call = Cdr.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @call }
      end
    end


    # DELETE /employees/1
    # DELETE /employees/1.xml
    def delete
      File.delete(params[:filename])
      File.delete(params[:sound_file])
      redirect_to :action => "index"
    end
    
    def call
      Action.introduce params[:source], params[:destination]
      render :nothing => true
    end
    
    private
    def get_voicemails(extension, status=:all)
      case status
      when :all
        file_path = VOICEMAIL_ROOT+"#{extension}/INBOX"
        files = []
        Dir.entries(file_path).each {|f| files << file_path + f if f.include? ".txt"}
        voice_mails = []
        files.each { |f| voice_mails << Voicemail.new(f) }
        voice_mails
      end      
    end
end
