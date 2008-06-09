class CallsController < ApplicationController
    before_filter :ensure_logged_in
    before_filter :ensure_admin, :except => :configure

    # GET /employees
    # GET /employees.xml
    def index
      @calls = Cdr.find(:all)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @calls }
      end
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
    def destroy
      @call = Cdr.find(params[:id])
      @call.destroy

      respond_to do |format|
        format.html { redirect_to calls_url }
        format.xml  { head :ok }
      end
    end
end
