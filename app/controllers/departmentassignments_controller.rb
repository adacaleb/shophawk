class DepartmentassignmentsController < ApplicationController
  before_action :set_departmentassignment, only: %i[ show edit update destroy ]

  # GET /departmentassignments or /departmentassignments.json
  def index
    @departmentassignments = Departmentassignment.all
  end

  # GET /departmentassignments/1 or /departmentassignments/1.json
  def show
  end

  # GET /departmentassignments/new
  def new
    @departmentassignment = Departmentassignment.new
  end

  # GET /departmentassignments/1/edit
  def edit
  end

  # POST /departmentassignments or /departmentassignments.json
  def create
    @departmentassignment = Departmentassignment.new(departmentassignment_params)

    respond_to do |format|
      if @departmentassignment.save
        format.html { redirect_to departmentassignment_url(@departmentassignment), notice: "Departmentassignment was successfully created." }
        format.json { render :show, status: :created, location: @departmentassignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @departmentassignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departmentassignments/1 or /departmentassignments/1.json
  def update
    respond_to do |format|
      if @departmentassignment.update(departmentassignment_params)
        format.html { redirect_to departmentassignment_url(@departmentassignment), notice: "Departmentassignment was successfully updated." }
        format.json { render :show, status: :ok, location: @departmentassignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @departmentassignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departmentassignments/1 or /departmentassignments/1.json
  def destroy
    @departmentassignment.destroy

    respond_to do |format|
      format.html { redirect_to departmentassignments_url, notice: "Departmentassignment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_departmentassignment
      @departmentassignment = Departmentassignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def departmentassignment_params
      params.require(:departmentassignment).permit(:departmentassignment)
    end
end
