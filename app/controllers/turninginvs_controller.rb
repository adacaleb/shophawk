class TurninginvsController < ApplicationController
  before_action :set_turninginv, only: %i[ show edit update destroy ]

  # GET /turninginvs or /turninginvs.json
  def index
      @q = Turninginv.ransack(params[:q])
      @turninginvs = @q.result


  end

  # GET /turninginvs/1 or /turninginvs/1.json
  def show
    @turninginv = Turninginv.find(params[:id])
    @histories = History.all
  end

  # GET /turninginvs/new
  def new
    @turninginv = Turninginv.new
  end

  # GET /turninginvs/1/checkout
  def checkout
    @turninginv = Turninginv.find(params[:id])
    @turninginv.to_take = nil #sets main box to zero at start of checkout everytime
    @turninginv.histories.new
  end

  # GET /turninginvs/1/edit
  def edit
    @turninginv.to_take = nil #set to clear to_take data just in case. 
  end

  # POST /turninginvs or /turninginvs.json
  def create
    @turninginv = Turninginv.new(turninginv_params)

    respond_to do |format|
      if @turninginv.save
        @turninginv.turninginv_id_assign
        format.html { redirect_to turninginvs_path, notice: "Tool was successfully created." }
        format.json { render :show, status: :created, location: @turninginv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turninginv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /turninginvs/1 or /turninginvs/1.json
  def update

    respond_to do |format|
      @turninginv.restock_check
      @turninginv.make_history
      if @turninginv.update(turninginv_params)
        @turninginv.update_balance
        format.html { redirect_to turninginvs_path, notice: "Tool was successfully changed." }
        format.json { render :show, status: :ok, location: @turninginv }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @turninginv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turninginvs/1 or /turninginvs/1.json
  def destroy
    @turninginv.destroy

    respond_to do |format|
      format.html { redirect_to turninginvs_url, notice: "Tool was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_turninginv
      @turninginv = Turninginv.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def turninginv_params
      params.require(:turninginv).permit(:part_number, :description, :to_take, :balance,         :remaining, :minumum, :location, :vendor, :buyer, :last_received, :last_email, :employee, :turninginv,
        history_attributes: [:hnew_balance, :hlast_email, :checkedin, :checkedout, :hpart_number, :turninginv_id])
    end
end
