class AssignmentsController < ApplicationController
  before_action :set_assignment, only: %i[ update destroy ]

  # GET /assignments or /assignments.json
  def index
    @department = Department.find_by(id: params[:departmentid])
    @assignments = @department.assignments
    @assignmentscount = @department.assignments.size
    case @assignmentscount 
    when 1 #sets number of columns for css "form-#-col"
      @columns = 1
    when 2
      @columns = 2
    when 3
      @columns = 3
    else
      @columns = 4
    end
  end


  # GET /assignments/new
  def new
    @department = Department.find_by(id: params[:departmentid]) #get matching department
    @departmentid = @department.id #save its ID. this is passed on with a hidden text field in the new assignment form
    @assignment = Assignment.new
  end


  # POST /assignments or /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        DepartmentAssignment.create(department_id: params[:departmentid], assignment_id: @assignment.id)
        #above line saves a new record in the join table DepartmentAssignment to associate the new assignment to the currently selected department
        format.html { redirect_to runlists_url(@runlists), notice: "Assignment was successfully created." }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to runlists_path, notice: "Assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1 or /assignments/1.json
  def destroy
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to runlists_url(@runlists), notice: "Assignment was successfully destroyed." }
      format.json { head :no_content }
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
