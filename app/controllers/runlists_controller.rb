class RunlistsController < ApplicationController
  before_action :set_runlist, only: %i[ show edit update destroy ]

  # GET /runlists or /runlists.json
  def index
    Runlist.importcsv
    @runlists = Runlist.all
    #@runlists.each.Job_Sched_End = @runlists.Job_Sched_End[0..3]

  end

  # GET /runlists/1 or /runlists/1.json
  def show
  end

  # GET /runlists/new
  def new
    @runlist = Runlist.new
  end

  # GET /runlists/1/edit
  def edit
  end

  # POST /runlists or /runlists.json
  def create
    @runlist = Runlist.new(runlist_params)

    respond_to do |format|
      if @runlist.save
        format.html { redirect_to runlist_url(@runlist), notice: "Runlist was successfully created." }
        format.json { render :show, status: :created, location: @runlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @runlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runlists/1 or /runlists/1.json
  def update
    respond_to do |format|
      if @runlist.update(runlist_params)
        format.html { redirect_to runlist_url(@runlist), notice: "Runlist was successfully updated." }
        format.json { render :show, status: :ok, location: @runlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @runlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runlists/1 or /runlists/1.json
  def destroy
    @runlist.destroy

    respond_to do |format|
      format.html { redirect_to runlists_url, notice: "Runlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_runlist
      @runlist = Runlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def runlist_params
      params.require(:runlist).permit(:Job, :Job_Operation, :WC_Vendor, :Operation_Service, :Vendor, :Sched_Start, :Sched_End, :Sequence, :Customer, :Order_Date, :Part_Number, :Rev, :Description, :Order_Quantity, :Extra_Quantity, :Pick_Quantity, :Make_Quantity, :Open_Operations, :Completed_Quantity, :Shipped_Quantity, :FG_Transfer_Qty, :In_Production_Quantity, :Certs_Required, :Act_Scrap_Quantity, :Customer_PO, :Customer_PO_LN, :Job_Sched_End, :Job_Sched_Start, :Note_Text, :Released_Date, :Material, :Mat_Vendor, :Mat_Description, :employee, :dots, :currentOp, :matWaiting)
    end
end
