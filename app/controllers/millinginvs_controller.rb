class MillinginvsController < ApplicationController
  before_action :set_millinginv, only: [ :show, :edit, :update, :destroy ]

  # GET /millinginvs or /millinginvs.json
  def index
      @mins = 0 #keeps track of how many tools are below min qty
      @ordered = 0
      @vendor = 0
      
      @millinginv = Millinginv.all #for restock button calculations
      if @millinginv.count == 1 #set variable to prevent redirect to checkout if only 1 tool in inventory
        tcheck = 1
      else
        tcheck = 0
      end
      @millinginv.each do |millinginv| 
        if millinginv.status == "Needs Restock" || millinginv.status == "In Cart"
          @mins = @mins + 1  #sets the parameter for the "to be ordered" button
        end
        if millinginv.status == "Ordered"
          @ordered = @ordered + 1
        end
        if millinginv.atvendor.to_i > 0
          @vendor = @vendor + 1
        end
        millinginv.number_of_checkouts.to_i
      end 

      #sets up buttons for need to be ordered/vendor/restock
       @mins > 1 ? s1 = "s" : s1 = nil 
       @mins > 0 ? @restock = "#{@mins} Tool#{s1} to Re-stock" : @restock = nil
       @ordered > 1 ? s2 = "s" : s1 = nil
       @ordered > 0 ? @order = "#{@ordered} Tool#{s2} On Order" : @order = nil 
       @ordered > 0 ? com2 = ", " : com2 = nil
       @vendor > 1 ? s3 = "s" : s3 =  nil
       @vendor > 0 ? @vend = "#{com2}#{@vendor} tool#{s3} at vendor" : @vend = nil

      @q = Millinginv.ransack(params[:q]) 
      @millinginvs = @q.result.sort_by(&:number_of_checkouts).reverse #auto-sort by checkout amount

      if @millinginvs.count == 1 and tcheck == 0 #if one tool found on search and there are more than 1 tools in database, goto checkout page for found tool
        redirect_to millingcheckout_path(@millinginvs)
      end
  end

  def belowmin #run on belowmin page open
      @q = Millinginv.ransack(params[:q])
      @millinginvs = @q.result.sort_by(&:number_of_checkouts).reverse
      @millinginv = Millinginv.all
  end


  # GET /millinginvs/1 or /millinginvs/1.json
  def show
    @millinginvs = Millinginv.all
    @millinginv = Millinginv.find(params[:id])
    @histories = History.all

    @tempid = @millinginv.id

    @q = Millinginv.ransack(params[:q]) 
    @millinginvs = @q.result.sort_by(&:number_of_checkouts).reverse #auto-sort by checkout amount
   end

  # GET /millinginvs/new
  def new
    @millinginv = Millinginv.new(:hardwareid => params[:hardwareid])
  end

  def checkout
    @millinginvs = Millinginv.all
    @millinginv = Millinginv.find(params[:id])
    @millinginv.to_take = nil #sets main box to zero at start of checkout everytime
  end

  def checkin
    @millinginvs = Millinginv.all
    @millinginv = Millinginv.find(params[:id])
    @millinginv.to_add = nil #sets main box to zero at start of checkout everytime
  end

def status #loops back to same page we're on instead of going to index page like normal update method
  @millinginv = Millinginv.find(params[:id])
    respond_to do |format|
      @millinginv.restock_check
      if @millinginv.update(millinginv_params)
        format.html { redirect_to millingbelowmin_path, notice: "status updated" }
        format.json { render :show, status: :created, location: @millinginv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @millinginv.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /millinginvs/1/edit
  def edit
    @millinginv.to_take = nil #set to clear to_take data just in case. 
  end

  # POST /millinginvs or /millinginvs.json
  def create
    @millinginv = Millinginv.new(millinginv_params)
    respond_to do |format|
      if @millinginv.save
        format.html { redirect_to millinginvs_path, notice: "Millinginv was successfully created." }
        format.json { render :show, status: :created, location: @millinginv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @millinginv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /millinginvs/1 or /millinginvs/1.json
  def update
    respond_to do |format|
      @millinginv.restock_check
      if @millinginv.update(millinginv_params)
        format.html { redirect_to millinginvs_path, notice: "Millinginv was successfully updated." }
        format.json { render :show, status: :ok, location: @millinginv }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @millinginv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /millinginvs/1 or /millinginvs/1.json
  def destroy
    @millinginv.destroy
    respond_to do |format|
      format.html { redirect_to millinginvs_url, notice: "Millinginv was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_millinginv
      @millinginv = Millinginv.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def millinginv_params
      params.require(:millinginv).permit(:part_number, :description, :to_take, :balance, :minumum, :atvendor, :location, :vendor, :buyer, :toolinfo, :last_received, :last_email, :employee, :hardwareid, :status, :orderdate, :to_add, :number_of_checkouts,
        histories_attributes: [:hnew_balance, :hlast_email, :checkedin, :checkedout, :hpart_number, :turninginv_id, :date])
    end
end
