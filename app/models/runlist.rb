class Runlist < ApplicationRecord
#	has_many :departments, through: :department_workcenters
#	has_many :department_workcenters, through: :workcenter
require 'csv'
require 'database_cleaner/active_record'
#The CSV Import code is running as a rake task save in /lib/tasks/csvimport.  It's then ran via a .bat file on the desktop "csvimport.bat", and ran via the windows task scheduler every 5 minutes
	
	def self.getDepartments
		#load and sort departments for select box
	    @departments = []
	    @d = Department.all
	    @d.each do |a|
	      @departments << a.department
	    end
	    return @departments.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 }
	end

	def self.getWorkcenters
		#Load and sort workcenters for select box
		@workCenters = [] #define empty array
    	@wcs = Workcenter.all
    	@wcs.each do |a| 
      		@workCenters << a.workCenter #creates array of just workcenters 
	    end
	    @workCenters.uniq! #narrows down array to only be unique workcenters
	    return @workCenters.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 } #sorts workcenter alphbetically
	end 

	def self.loadOperations(workCentersToShow, isDepartment, showStarted)
		show = []
		if showStarted == true #sets variable to compare against to render started jobs or not based on status
			show = ["S", "O"]
		else
			show = ["O"]
		end
		@operations = Runlist.where(WC_Vendor: workCentersToShow, status: show) 
	    @operations = @operations.sort { |a,b| (a.Sched_Start == b.Sched_Start) ? a.Job <=> b.Job : a.Sched_Start <=> b.Sched_Start } #sorts runListItem[0] by schedule start date, then job # within
	    if isDepartment == true
	    	@operations = @operations.sort { |a,b| (a.Sched_Start == b.Sched_Start) ? a.WC_Vendor <=> b.WC_Vendor : a.Sched_Start <=> b.Sched_Start } #sorts runListItem[0] by schedule start date, then job # within
	    end
	    @operations.each do |op| #sorts the date field to look correct for user
	      year = op.Sched_Start[0..3]
	      day = op.Sched_Start[8..9]
	      month = op.Sched_Start[5..7]
	      op.Sched_Start = "#{month}#{day}-#{year}"
	    end
	    return @operations
	end

	def self.updateRunList #Checks for new operations that haven't been added to DB, and saves them
		runListItems = self.csvToArrayOfHashes("runListOps", "tempjobs", "tempmat") #Creates combined array of hashes from the called out csv files
		#need above line to get list of ALL operations, new or old.  next if statement has options if in db already or not
		newImports = [] #new operations to save to DB
		runListItems.each do |op|
			current = Runlist.find_by(Job_Operation: op[:Job_Operation])
			if current == nil #if this is a new operation not found in the database, add it to array to import at the end
				#binding.pry
				newOp = self.newJobOp(op[:Job_Operation]) #pulls data from yearly csv exports to populate fields of new operations
				newImports << newOp #append to array
			else #if the record is found, we are going to update the current record with what's different
				#overwrite fields that are important with new data
				current.status = op[:status]
				current.Sched_Start = op[:Sched_Start]
				current.Sched_End = op[:Sched_End]
				
				
				current.save
				self.statusCalculations(op[:Job])
			end
		end
		#puts newImports.count #how many new operations are being saved
		Runlist.import newImports
	end


	def self.statusCalculations(opJob)
		job = Runlist.where(Job: opJob)
		job = job.sort_by { |a| a.Sequence }
		found = false
		foundMatWaiting = false
		matCancel = false
		job.each do |op|
			#puts op.Sequence
			#calculate current location
			if found == true
					op.currentOp = @foundOp
			else
				if op.status == "O" || op.status == "S"
					@foundOp = op.WC_Vendor
					op.currentOp  = @foundOp
					found = true
				end
			end
			#Calculate if material pending should be turned off
			if matCancel == true
				op.matWaiting = false
			else
				if op.WC_Vendor == "A-SAW" && op.status == "C"
					matCancel = true
					op.matWaiting = false
				end
				if op.WC_Vendor == "IN" && op.status == "C"
					matCancel = true
					op.matWaiting = false
				end
			end
			#calculate if material is pending
			if foundMatWaiting == true
				op.matWaiting = true
			else
				if op.status == "O" && op.WC_Vendor == "IN"
					foundMatWaiting = true
					op.matWaiting = true
				end
			end

			
			op.save #Saves the new currentop value if it's different
		end
	end


	def self.csvToArrayOfHashes(ops, job, mats)
		runListItems = [] #empties array for new csv import
		old = Runlist.where.not(employee: [nil, ""], dots: [nil, ""], matWaiting: [nil, "", false], Material: [nil, ""]) #saves what's altered to pass on later
		CSV.foreach("app/assets/csv/#{ops}.csv", headers: true, :col_sep => "`") do |row| #imports initial csv and creates all arrays needed
			#Below line filters out old/unwanted operations
			if row[2].to_s == "Y-WELD" || row[2].to_s == "---------" || row[2].to_s == "Y-TOOTHRND" || row[2].to_s == "Y-MILL" || row[2].to_s == "Y-KEYSEAT" || row[2].to_s == "Y-HT" || row[2].to_s == "Y-HOB" || row[2].to_s == "Y-GRIND" || row[2].to_s == "Y-BROACH" || row[2].to_s == "REMODEL" || row[2].to_s == "SHIP -HELP" || row[2].to_s == "" || row[2].to_s == "VOLUNTEER" || row[2].to_s == "Y-TURN" || row[5] == "NULL"
			else
				runListItems << {
		    	Job: row[0], 
		    	Job_Operation: row[1], 
		    	WC_Vendor: row[2],
		    	Operation_Service: row[3],
		    	Vendor: row[4],
		    	Sched_Start: row[5],
		    	Sched_End: row[6],
			    Sequence: row[7],
				status: row[8],


			    Customer: "", 
				Order_Date: "", 
				Part_Number: "", 
				Rev: "", 
				Description: "", 
				Order_Quantity: "", 
				Extra_Quantity: "", 
				Pick_Quantity: "", 
				Make_Quantity: "",
				Open_Operations: "", 
				Completed_Quantity: "", 
				Shipped_Quantity: "", 
				FG_Transfer_Qty: "", 
				In_Production_Quantity: "", 
				Certs_Required: "", 
				Act_Scrap_Quantity: "", 
				Customer_PO: "", 
				Customer_PO_LN: "", 
				Job_Sched_End: "", 
				Job_Sched_Start: "", 
				Note_Text: "", 
				Released_Date: "",

				Material: "", 
	    		Mat_Vendor: "",
	    		Mat_Description: "",

	    		employee: "",
				dots: "",
				currentOp: "",
				matWaiting: ""
		    	}
		    end
		end
		#runListrunListItem[0].reverse! #reserves array so sequence numbers are in order for current location calculation
		jobs = [] #new array for jobs csv
		CSV.foreach("app/assets/csv/#{job}.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			jobs << {
				Job: row[0],
				Customer: row[1], 
				Order_Date: row[2], 
				Part_Number: row[3], 
				Rev: row[4], 
				Description: row[5], 
				Order_Quantity: row[6], 
				Extra_Quantity: row[7], 
				Pick_Quantity: row[8], 
				Make_Quantity: row[9],
				Open_Operations: row[10], 
				Completed_Quantity: row[11], 
				Shipped_Quantity: row[12], 
				FG_Transfer_Qty: row[13], 
				In_Production_Quantity: row[14], 
				Certs_Required: row[15], 
				Act_Scrap_Quantity: row[16], 
				Customer_PO: row[17], 
				Customer_PO_LN: row[18], 
				Job_Sched_End: row[19], 
				Job_Sched_Start: row[20], 
				Note_Text: row[21], 
				Released_Date: row[22]
			}
		end
		mat = [] #new array for material import
		CSV.foreach("app/assets/csv/#{mats}.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			mat << {
				Job: row[0],
				Material: row[1], 
		      	Mat_Vendor: row[2],
		      	Mat_Description: row[3]
				}
				#Below is saved for calculating if material pending should be removed or added after all merging is done. 
		end		
		runListItems.reverse! #reserves array so sequence numbers are in order for current location calculation
		runListItems.each do |runListItems| #parses through each item and merges with mat and jobs array
			schedSrt = runListItems[:Sched_Start].to_s #reorganizes and prepares date field for sorting at end
			if schedSrt == "NULL"
					schedSrt = ""
			else
			end
			#calculate current location
			if @firstWc == nil #initialize variable
				@firstWc = runListItems[:WC_Vendor]
			end
			if runListItems[:Job] == @lastJob && runListItems[:status] != "C" #set currentOp for runListItem[0]
				runListItems[:currentOp] = @firstWc
			else
				@firstWc = runListItems[:WC_Vendor]
				runListItems[:currentOp] = @firstWc
			end
			#merge Jobs data
			jobs.each do |row|
				schEnd = row[:Job_Sched_End].to_s #reorganize date field
				if schEnd == "NULL"
					schEnd = ""
				else
					year = schEnd[0..3]
					day = schEnd[8..9]
					month = schEnd[5..7]
					schEnd = "#{month}#{day}-#{year}"
				end
				if runListItems[:Job] == row[:Job] 
					runListItems[:Customer] = row[:Customer]
					runListItems[:Order_Date] = row[:Order_Date]
					runListItems[:Part_Number] = row[:Part_Number]
					runListItems[:Rev] = row[:Rev]
					runListItems[:Description] = row[:Description]
					runListItems[:Order_Quantity] = row[:Order_Quantity]
					runListItems[:Extra_Quantity] = row[:Extra_Quantity]
					runListItems[:Pick_Quantity] = row[:Pick_Quantity]
					runListItems[:Make_Quantity] = row[:Make_Quantity]
					runListItems[:Open_Operations] = row[:Open_Operations]
					runListItems[:Completed_Quantity] = row[:Open_Operations]
					runListItems[:Shipped_Quantity] = row[:Shipped_Quantity]
					runListItems[:FG_Transfer_Qty] = row[:FG_Transfer_Qty]
					runListItems[:In_Production_Quantity] = row[:In_Production_Quantity]
					runListItems[:Certs_Required] = row[:Certs_Required]
					runListItems[:Act_Scrap_Quantity] = row[:Act_Scrap_Quantity]
					runListItems[:Customer_PO] = row[:Customer_PO]
					runListItems[:Customer_PO_LN] = row[:Customer_PO_LN]
					runListItems[:Job_Sched_End] = schEnd
					runListItems[:Job_Sched_Start] = row[:Job_Sched_Start]
					runListItems[:Note_Text] = row[:Note_Text] 
					runListItems[:Released_Date] = row[:Released_Date]
					break
				end
			end
			#merge material data
			mat.each do |row|
				if runListItems[:Job] == row[:Job]
					runListItems[:Material] = row[:Material]
					runListItems[:Mat_Vendor] = row[:Mat_Vendor]
					runListItems[:Mat_Description] = row[:Mat_Description]
					break
				end
			end
			if runListItems[:Material] == ""
				runListItems[:Material] = "Customer Supplied"
			end
			
			#imports data previously saved from users into these jobs
			old.each do |data| 
				if data[:Job_Operation].to_s == runListItems[:Job_Operation].to_s
					runListItems[:employee] = data.employee
					runListItems[:matWaiting] = data.matWaiting
					runListItems[:dots] = data.dots
					#material export includes the exact previous year of data for import
					break
				end
			end
			@lastJob = runListItems[:Job].to_s
		end
		return runListItems
	end

	def self.newJobOp(jobOp)

		runListItem = [] #empties array for new csv import
		CSV.foreach('app/assets/csv/yearlyRunListOps.csv', headers: true, :col_sep => "`") do |row| #imports initial csv and creates all arrays needed
			if jobOp == row[1]
				runListItem << {
		    	Job: row[0], 
		    	Job_Operation: row[1], 
		    	WC_Vendor: row[2],
		    	Operation_Service: row[3],
		    	Vendor: row[4],
		    	Sched_Start: row[5],
		    	Sched_End: row[6],
			    Sequence: row[7],
				status: row[8],


			    Customer: "", 
				Order_Date: "", 
				Part_Number: "", 
				Rev: "", 
				Description: "", 
				Order_Quantity: "", 
				Extra_Quantity: "", 
				Pick_Quantity: "", 
				Make_Quantity: "",
				Open_Operations: "", 
				Completed_Quantity: "", 
				Shipped_Quantity: "", 
				FG_Transfer_Qty: "", 
				In_Production_Quantity: "", 
				Certs_Required: "", 
				Act_Scrap_Quantity: "", 
				Customer_PO: "", 
				Customer_PO_LN: "", 
				Job_Sched_End: "", 
				Job_Sched_Start: "", 
				Note_Text: "", 
				Released_Date: "",

				Material: "", 
	    		Mat_Vendor: "",
	    		Mat_Description: "",

	    		employee: "",
				dots: "",
				currentOp: "",
				matWaiting: ""
		    	}
		    	break
		    end
		end
		
		
		CSV.foreach('app/assets/csv/yearlyJobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			#binding.pry
			if row[0] == runListItem[0][:Job]

				schEnd = row[19].to_s #reorganize date field
				if schEnd == "NULL"
					schEnd = ""
				else
					year = schEnd[0..3]
					day = schEnd[8..9]
					month = schEnd[5..7]
					schEnd = "#{month}#{day}-#{year}"
				end
				runListItem[0][:Customer] = row[1]
				runListItem[0][:Order_Date] = row[2]
				runListItem[0][:Part_Number] = row[3]
				runListItem[0][:Rev] = row[4]
				runListItem[0][:Description] = row[5]
				runListItem[0][:Order_Quantity] = row[6]
				runListItem[0][:Extra_Quantity] = row[7]
				runListItem[0][:Pick_Quantity] = row[8]
				runListItem[0][:Make_Quantity] = row[9]
				runListItem[0][:Open_Operations] = row[10]
				runListItem[0][:Completed_Quantity] = row[11]
				runListItem[0][:Shipped_Quantity] = row[12]
				runListItem[0][:FG_Transfer_Qty] = row[13]
				runListItem[0][:In_Production_Quantity] = row[14]
				runListItem[0][:Certs_Required] = row[15]
				runListItem[0][:Act_Scrap_Quantity] = row[16]
				runListItem[0][:Customer_PO] = row[17]
				runListItem[0][:Customer_PO_LN] = row[18]
				runListItem[0][:Job_Sched_End] = schEnd
				runListItem[0][:Job_Sched_Start] = row[20]
				runListItem[0][:Note_Text] = row[21] 
				runListItem[0][:Released_Date] = row[22]
				break
			end
		end
		CSV.foreach('app/assets/csv/yearlyMat.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			#binding.pry
			if row[0] == runListItem[0][:Job]
				runListItem[0][:Material] = row[1]
				runListItem[0][:Mat_Vendor] = row[2]
				runListItem[0][:Mat_Description] = row[3]
				break
			end
		end
		if runListItem[0][:Material] == ""
					runListItem[0][:Material] = "Customer Supplied"
		end
		return runListItem[0]
	end

	#the code that imports the CSV's from JObboss is in ~/lib/tasks/csvimport.rake
	def self.importcsv
		#clears db and imports all data from last 13 months
		runListItems = self.csvToArrayOfHashes("yearlyRunListOps", "yearlyJobs", "yearlyMat")

		DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets runlists database table
		Runlist.import runListItems #imports new array of hashes to Database

		#check once a day for new Workcenters from Jobboss and import if needed
		@runlists = Runlist.all
		@wcs = [] #initialize array
		@runlists.each do |r| #make lists of workcenters
			@wcs << r.WC_Vendor
		end
	    @wcs.uniq! #narrows down array to only be unique workcenters
	    @wcs.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 } #sorts workcenter alphbetically
		@wcs.each do |a| #check if the WC exists in Workcenter model, if not, save it into the DB
		    if Workcenter.exists?(workCenter: a) #if the workcenter does not exist in our list, add it to the list
		    else
		      @workcenter = Workcenter.new(workCenter: a)
		      @workcenter.save
		    end
		end
	end

	

	


end