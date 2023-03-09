class RunlistsController < ApplicationController
  require 'date'
  helper_method :dailyHoursCalc #helper method's are available to use from the view pages

  def dailyHoursCalc(date, operations) #Called from view to get hours for each day
    #testy = operations[Sched_Start:]
    estimatedTime = 0
    operations.each do |op|
      if op.Sched_Start.to_s == date.to_s
        estimatedTime = estimatedTime.to_f + op.EstTotalHrs.to_f
      end
    end
    return estimatedTime.round(2)
  end

  # GET /runlists or /runlists.json
  def index
    @workCenters = Runlist.getWorkcenters
    @departments = Runlist.getDepartments
  end

  def activerunlist #loads up selected Workcenter for Runlist
    @today = Date.today#.strftime('%m-%d-%Y')
    @departments = Runlist.getDepartments
    #load all operations that match the select field chosen sent over using runlist_controller.js
    @operations = Runlist.loadOperations(params[:wc], false, true)
    @as = [] #empty assignments array

    @oneDots = []
    @twoDots = []
    @threeDots = []
    @operations.each do |op|
      case op.dots
      when 1
        @oneDots << [op.Job, op.Sched_Start]
      when 2
        @twoDots << [op.Job, op.Sched_Start]
      when 3 
        @threeDots << [op.Job, op.Sched_Start]
      end
    end
    if @oneDots.any? || @twoDots.any? || @threeDots.any?
      @dots = true
    end
    @oneDots, @twoDots, @threeDots, @dots =  Runlist.calculateDots(@operations)
    @isDepartment = false
    #@oneWeekLoad, @twoWeekLoad, @threeWeekLoad, @fourWeekLoad = Runlist.calculateWeeklyLoad(@operations, @department)
  end

  def changedepartment
    @today = Date.today #.strftime('%m-%d-%Y')
    @workCenters = Runlist.getWorkcenters
    #makes a list of all workcenters in the department that matches data sent from runlist.js
    @department = Department.find_by(department: params[:department]) 
    @departmentid = @department.id
    @workCentersToShow = [] #initiate array
    @department.workcenters.each do |a| #for the department, load the associated workCenters to the array
      @workCentersToShow << a.workCenter
    end
    @operations = Runlist.loadOperations(@workCentersToShow, true, @department.started)
    #load assignments for the selected department
    @assignments = @department.assignments
    @as = []
    @assignments.each do |a|
      @as << a.assignment
    end
    #Dots and weekly load information
    @oneDots, @twoDots, @threeDots, @dots =  Runlist.calculateDots(@operations)
    if @department.capacity == 0 then @department.capacity = nil end
    if @department.capacity.present?
      @oneWeekLoad, @twoWeekLoad, @threeWeekLoad, @fourWeekLoad = Runlist.calculateWeeklyLoad(@operations, @department)
      @isDepartment = true
    else
      @isDepartment = false
    end
    
  end

  def checkboxsubmit #updates checkbox value when toggled
    @runlist = Runlist.find_by_id params[:id]
    if @runlist.matWaiting == nil 
      @runlist.matWaiting = false
    end
    @runlist.matWaiting = !@runlist.matWaiting #toggles between true and false
    @runlists = Runlist.where(Job: @runlist.Job) #get every other job with same job number
    @runlists.each do |job| 
      job.matWaiting = !job.matWaiting #set the material waiting boolean to be the same of initial checkbox to be opposite whatever it is. 
      job.save 
    end
  end

  def newassignment
    @department = Department.find_by(id: params[:departmentid]) #get matching department
    #@departmentName = @department.department
    @departmentid = @department.id #save its ID. this is passed on with a hidden text field in the new assignment form
    @assignment = Assignment.new
  end

  def createassignment
    @assignment = Assignment.new(assignment: params[:assignment])
    @department = Department.find_by_id(params[:departmentid])

    #@workCenters = Runlist.getWorkcenters
    #binding.pry
    @assignment.save
    DepartmentAssignment.create(department_id: params[:departmentid], assignment_id: @assignment.id)
    render 'runlists/changedepartment', department: @department 

#    respond_to do |format|
#      if @assignment.save
#        DepartmentAssignment.create(department_id: params[:departmentid], assignment_id: @assignment.id)
        #above line saves a new record in the join table DepartmentAssignment to associate the new assignment to the currently selected department
 #       format.html { render changedepartment_runlists_path(:department => @department.department), notice: "Assignment was successfully created." }
#        format.json { render :show, status: :created, location: @assignment }
#      else
        #format.html { render :new, status: :unprocessable_entity }
        #format.json { render json: @assignment.errors, status: :unprocessable_entity }
#      end
 #   end
  end

  def showAssignments
    @department = Department.find_by(id: params[:departmentid])
    @assignments = @department.assignments

    @today = Date.today #.strftime('%m-%d-%Y')
    @workCenters = Runlist.getWorkcenters
    #makes a list of all workcenters in the department that matches data sent from runlist.js
    @department = Department.find_by(department: params[:department]) 
    @workCentersToShow = [] #initiate array
    @department.workcenters.each do |a| #for the department, load the associated workCenters to the array
      @workCentersToShow << a.workCenter
    end
    @operations = Runlist.loadOperations(@workCentersToShow, true, @department.started)
    #load assignments for the selected department
    @assignments = @department.assignments
    @as = []
    @assignments.each do |a|
      @as << a.assignment
    end

  end

  def assignmentsubmit
    @runlist = Runlist.find_by_id params[:id]
    @runlist.employee = params[:assignment]
    @runlist.save
  end

  def closestreams
  end

  def destroyassignment
    @assignment = Assignment.find(params[:id])
    #binding.pry
    @assignment.destroy


    respond_to do |format|
      format.html { redirect_to showAssignments_runlists_path( :departmentid => params[:departmentid], :department => params[:department]), notice: "Assignment was successfully destroyed." }
      format.json { head :no_content }
    end



  end



end
