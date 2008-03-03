class EmployeesController < ApplicationController
  
  before_filter :ensure_logged_in, :except => :login
  
  # GET /employees
  # GET /employees.xml
  def index
    @employees = Employee.find(:all, :order => :extension)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.xml
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.xml
  def new
    @employee = Employee.new :extension => Employee.next_available_extension, :encrypted_password => 
    @groups   = Group.find(:all).map { |group| [group, false] }
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find params[:id]
    @groups = Group.find(:all, :include => :employees).map do |group|
      [group, group.employees.include?(@employee)]
    end
  end

  # POST /employees
  # POST /employees.xml
  def create
    @employee = Employee.new(params[:employee])
    
    respond_to do |format|
      if @employee.valid?
        reassign_employee_memberships
        flash[:notice] = 'Employee was successfully created.'
        format.html { redirect_to :action => :next_steps, :id => @employee }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        flash[:error] = @employee.errors.full_messages.join "<br/>" # Fucking gross...
        format.html { redirect_to :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def next_steps
    @employee = Employee.find(params[:id])
  end

  # PUT /employees/1
  # PUT /employees/1.xml
  def update
    @employee = Employee.find(params[:id])
    
    reassign_employee_memberships
    
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = 'Employee was successfully updated.'
        format.html { redirect_to(@employee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def call
    Action.introduce params[:source], params[:destination]
    render :nothing => true
  end

  # DELETE /employees/1
  # DELETE /employees/1.xml
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def reassign_employee_memberships
    @employee.save
    Membership.destroy_memberships_for_employee @employee
    params.keys.map(&:to_s).grep(/^group_/).map { |key| Group.find(key[/\d+$/]) }.each do |group|
      @employee.memberships.create :group => group
    end
    @employee.save
  end
  
end
