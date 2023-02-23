class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[ update destroy ]

  # GET /assignments or /assignments.json
  def index
    @department = Department.find_by(id: params[:departmentid])
    @assignments = @department.assignments

  end


  # GET /assignments/new
  def new
    @department = Department.find_by_id( params[:departmentid] ) #get matching department
    @departmentid = @department.id #save its ID. this is passed on with a hidden text field in the new assignment form
    @assignment = Assignment.new
  end


  # POST /assignments or /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)
    @department = Department.find_by(department: params[:department]) 
    #@workCenters = Runlist.getWorkcenters
    #binding.pry
    respond_to do |format|
      if @assignment.save
        DepartmentAssignment.create(department_id: params[:departmentid], assignment_id: @assignment.id)
        #above line saves a new record in the join table DepartmentAssignment to associate the new assignment to the currently selected department
        format.html { redirect_to runlists_path, notice: "Assignment was successfully created." }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_params
      params.require(:assignment).permit(:assignment)
    end
end
