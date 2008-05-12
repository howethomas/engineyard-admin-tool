class EmployeesController < ApplicationController
  
  before_filter :ensure_logged_in
  before_filter :ensure_admin, :except => :configure
  
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
    @employee = Employee.new :extension => Employee.next_available_extension
    @employee.password = Employee.new_random_temp_password
    @groups   = Group.find(:all).map { |group| [group, false] }
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee ||= Employee.find params[:id]
    @groups = Group.find(:all, :include => :employees).map do |group|
      [group, group.employees.include?(@employee)]
    end
  end

  # POST /employees
  # POST /employees.xml
  def create
    @employee = Employee.new(params[:employee])
    
    selected_groups = params.keys.grep(/^group_/).map { |group| group[/^group_(\d+)$/, 1] }
    @groups = Group.find(:all).map { |group| [group, selected_groups.include?(group.name)] }
    
    respond_to do |format|
      if @employee.valid?
        reassign_employee_memberships # saves the employee
        PasswordMailer.deliver_new_password(@employee)
        flash[:notice] = 'Employee was successfully created.'
        format.html { redirect_to :action => :next_steps, :id => @employee }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        format.html { render :action => :new }
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
    @employee.availability_rules = availability_rules_from_params
    
    reassign_employee_memberships
    
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = 'Employee was successfully updated.'
        format.html { redirect_to(@employee) }
        format.xml  { head :ok }
      else
        format.html do
          flash[:error] = @employee.errors.full_messages
          redirect_to :action => "edit"
        end
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def configure
    @employee = @logged_in_user
    @employees = Employee.find(:all, :order => "extension")
    @full_size_container = true
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
      format.html { redirect_to employees_url }
      format.xml  { head :ok }
    end
  end
  
  private

  def availability_rules_from_params
    returning Array.new(7) { [false] * 24 } do |rules|
      params.each do |(key, value)|
        match = key.to_s.match /^available_(\d+)_(\d+)$/
        next unless match
        x,y = match.captures.map(&:to_i)
        rules[x][y] = true
      end
    end
  end
  
  def reassign_employee_memberships
    @employee.save
    Membership.destroy_memberships_for_employee @employee
    params.keys.map(&:to_s).grep(/^group_/).map { |key| Group.find(key[/\d+$/]) }.each do |group|
      @employee.memberships.create :group => group
    end
    @employee.save
  end
  
end
