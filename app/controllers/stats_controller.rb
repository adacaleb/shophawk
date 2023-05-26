require 'csv'
require 'date'
include Caleb #file located in ~/lib/reusable.rb for methods to work accross any controller/model that includes the Reuasable module
class StatsController < ApplicationController
  before_action :set_stat, only: %i[ show edit update destroy ]

	# GET /stats or /stats.json
	def index
	@stats = Stat.all
	@txs, @balance = checkbook #call checkbook method
	openInvoices
	end

	def openInvoices
		i = 0
		@openInv = []
		@totalOpen = 0
		 #:quote_char => "|",
		open("app/assets/csv/Open_Invoice_Amounts.csv").read.force_encoding('utf-8')
		CSV.foreach("app/assets/csv/Open_Invoice_Amounts.csv", headers: true, invalid: :replace, replace: "", :col_sep => "`") do |row|
			#puts row[0]
			if i > 0
				case row[3] #Terms paid from invoice date
				when "Net 30 days", "1% 10 Net 30", "2% 10 Net 30" #earn a discount if paid within 10 days
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "30",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				when "Net 45 Days", "2% 10 NET 45"
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "45",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				when "NET 60 DAYS"
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "60",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				when "Net 60 mth end" #need to pay within 60 days from the end of the month the invoice was sent
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "60+",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				when "Net 75 Days"
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "75",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				when "NET 90 DAYS"
					@openInv << {
						invoice: row[0],
						customer: row[1],
						invoiceDate: row[4],
						dueDate: row[5],
						invoiceAmount: row[6].to_f,
						openAmount: row[7].to_f,
						lastUpdated: row[8],
						terms: "90",
						late: false,
						daysOpen: "",
						period: ""
					}
					@totalOpen = @totalOpen + row[6].to_f
				end
			end
		i = i + 1
		end
		today = Date.today.to_s
		thirty = Date.today + 30
		fourtyFive = Date.today + 45
		sixty = Date.today + 60
		ninety = Date.today + 90
		@lateDue = 0
		@thirtyDue = 0
		@fourtyFiveDue = 0
		@sixtyDue = 0
		@ninetyDue = 0
		@openInv.each do |inv|
			inv[:dueDate] = inv[:dueDate][0..9]
			idate = inv[:invoiceDate][0..9].to_date
			inv[:daysOpen] = (Date.today - idate).to_i
			 #calculate amounts due for each time period
			if inv[:dueDate] < today
				inv[:late] = true
				@lateDue = @lateDue + inv[:openAmount]
			end
			if inv[:daysOpen] >= 0 && inv[:daysOpen] <= 30
				@thirtyDue = @thirtyDue + inv[:openAmount]
				inv[:period] = 1
			end
			if inv[:daysOpen] > 30 && inv[:daysOpen] <= 60
				@fourtyFiveDue = @fourtyFiveDue + inv[:openAmount]
				inv[:period] = 2
			end
			if inv[:daysOpen] > 60 && inv[:daysOpen] <= 90
				@sixtyDue = @sixtyDue + inv[:openAmount]
				inv[:period] = 3
			end
			if inv[:daysOpen] > 90
				@ninetyDue = @ninetyDue + inv[:openAmount]
				inv[:period] = 4
			end
			inv[:dueDate] = Caleb.sortDate(inv[:dueDate])
			inv[:invoiceDate] = Caleb.sortDate(inv[:invoiceDate])
		end
		@render = @openInv
		return @openInv
	end

	def openinv
		@openInv = openInvoices
		@render = []
		@openInv.each do |inv|
			case params[:period]
			when "late"
				if inv[:late] == true
					@render << inv
				end
			when "All"
				@render << inv
			when "30"
				if inv[:daysOpen] >= 0 && inv[:daysOpen] <= 30
					@render << inv
				end	
			when "60"
				if inv[:daysOpen] > 30 && inv[:daysOpen] <= 60
					@render << inv
				end	
			when "90"
				if inv[:daysOpen] > 60 && inv[:daysOpen] <= 90
					@render << inv
				end	
			when "90+"
				if inv[:daysOpen] > 90
					@render << inv
				end	
			end
		end
	end

	def checkbook
	  	i = 0
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
		return @txs.reverse!, @balance
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
