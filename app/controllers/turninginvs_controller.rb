class TurninginvsController < ApplicationController
  before_action :set_turninginv, only: [ :show, :edit, :update, :destroy ]

 # GET /turninginvs or /turninginvs.json
  def index
      @mins = 0 #keeps track of how many tools are below min qty
      @ordered = 0
      
      @turninginv = Turninginv.all #for restock button calculations
      @turninginv.each do |turninginv| 
        if turninginv.status == "Needs Restock" || turninginv.status == "In Cart"
          @mins = @mins + 1  #sets the parameter for the "to be ordered" button
        end
        if turninginv.status == "Ordered"
          @ordered = @ordered + 1
        end
        turninginv.number_of_checkouts.to_i
      end 





       #sets up buttons for need to be ordered/vendor/restock
       @mins > 1 ? s1 = "s" : s1 = nil 
       @mins > 0 ? @restock = "#{@mins} Tool#{s1} to Re-stock" : @restock = nil
       @ordered > 1 ? s2 = "s" : s1 = nil
       @ordered > 0 ? @order = "#{@ordered} Tool#{s2} On Order" : @order = nil 
       @ordered > 0 ? com2 = ", " : com2 = nil



      @q = Turninginv.ransack(params[:q]) 
      @turninginvs = @q.result.sort_by(&:number_of_checkouts).reverse #auto-sort by checkout amount
  end

  def belowmin #run on belowmin page open
      @q = Turninginv.ransack(params[:q])
      @turninginvs = @q.result.sort_by(&:number_of_checkouts).reverse
      @turninginv = Turninginv.all
  end

  # GET /turninginvs/1 or /turninginvs/1.json
  def show
    @turninginvs = Turninginv.all
    @turninginv = Turninginv.find(params[:id])
    @histories = History.all

    @tempid = @turninginv.id

    @q = Turninginv.ransack(params[:q]) 
    @turninginvs = @q.result.sort_by(&:number_of_checkouts).reverse #auto-sort by checkout amount
  end

  # GET /turninginvs/new
  def new
      @turninginv = Turninginv.new(:hardwareid => params[:hardwareid])
  end

  def checkout
    @turninginvs = Turninginv.all
    @turninginv = Turninginv.find(params[:id])
    @turninginv.to_take = nil #sets main box to zero at start of checkout everytime
  end

  def checkin
    @turninginvs = Turninginv.all
    @turninginv = Turninginv.find(params[:id])
    @turninginv.to_add = nil #sets main box to zero at start of checkout everytime
  end

  def status
    @turninginv = Turninginv.find(params[:id])
    respond_to do |format|
      if @turninginv.update(turninginv_params)
        format.html { redirect_to turningbelowmin_path, notice: "status updated" }
        format.json { render :show, status: :created, location: @turninginv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @turninginv.errors, status: :unprocessable_entity }
      end
    end
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
      if @turninginv.update(turninginv_params)
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
      params.require(:turninginv).permit(:part_number, :description, :toolinfo, :to_take, :to_add, :balance, :remaining, :minumum, :location, :vendor, :hardwareid, :buyer, :last_received, :last_email, :employee, :number_of_checkouts, :checkedin, :checkedout, :status, :turninginv,
        histories_attributes: [:hnew_balance, :hlast_email, :checkedin, :checkedout, :hpart_number, :turninginv_id, :date])
    end
end
