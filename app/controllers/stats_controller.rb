require 'csv'
include Caleb #file located in ~/lib/reusable.rb for methods to work accross any controller/model that includes the Reuasable module
class StatsController < ApplicationController
  before_action :set_stat, only: %i[ show edit update destroy ]

  # GET /stats or /stats.json
  def index
  	i = 0
    @stats = Stat.all

    @bankhistory = []
    @txs = []
    CSV.foreach("app/assets/csv/bankhistory.csv", headers: true, :col_sep => "`") do |row|
    	if i == 1
	    	@bankhistory << {
	    		Statement_Date: row[0],
	    		Beginning_Balance: row[1],
	    		Ending_Balance: row[2],
	    		Account_Ending_Bal: row[3],
	    		Outstanding_Checks: row[4],
	    		Cleared_Deposits: row[5],
	    		Cleared_Checks: row[6],
	    		Last_Updated: row[7],
	    	}
	    	i = 0
	    	@statementDate = Caleb.sortDate(row[0])
	    	break
	    else
	    	i = i + 1
	    end
	end
	#puts @statementDate
	#puts @bankhistory[0][:Beginning_Balance]
	#puts @bankhistory[0][:Account_Ending_Bal].to_f
	@balance = @bankhistory[0][:Account_Ending_Bal].to_f

	CSV.foreach("app/assets/csv/Journal_Entry.csv", headers: true, encoding:'iso-8859-1:utf-8', :col_sep => "`") do |row|
    	if i > 0 && row[2] != nil
			date = Caleb.sortDate(row[2])
			if date > @statementDate
				@balance = @balance + row[1].to_f
				if row[3].to_f == 9999 then source = "9999 - ACH Check" else source = row[3] end
			   	@txs << {
			   		Source: row[0],
		    		Reference: source,
		    		date: date,
		    		amount: row[1].to_f,
		    		Last_Updated: row[4]
		    		#	0[Source]
					#	1,[Amount]
					#	2,[Transaction_Date]
					#	3,[Reference]
					#	4,[Last_Updated]
					#	,[Type]
					#	,[Creation_Date]
					#	,[GL_Account]
		    	}
	    	end
	    end
	    i = i + 1
	end

	i = 0	
	@txs.sort_by! { |a| a[:date] }
	@txs.reverse!
  end

  # GET /stats/1 or /stats/1.json
  def show
  end

  # GET /stats/new
  def new
    @stat = Stat.new
  end

  # GET /stats/1/edit
  def edit
  end

  # POST /stats or /stats.json
  def create
    @stat = Stat.new(stat_params)

    respond_to do |format|
      if @stat.save
        format.html { redirect_to stat_url(@stat), notice: "Stat was successfully created." }
        format.json { render :show, status: :created, location: @stat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stats/1 or /stats/1.json
  def update
    respond_to do |format|
      if @stat.update(stat_params)
        format.html { redirect_to stat_url(@stat), notice: "Stat was successfully updated." }
        format.json { render :show, status: :ok, location: @stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1 or /stats/1.json
  def destroy
    @stat.destroy

    respond_to do |format|
      format.html { redirect_to stats_url, notice: "Stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stat_params
      params.fetch(:stat, {})
    end
end
