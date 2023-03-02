require 'csv'
require 'database_cleaner/active_record'
namespace :import do 
	task :csv => :environment do 


		def csvToArrayOfHashes(ops, job, mats)
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
					EstTotalHrs: row[9],


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


		#*****************below runs to clear and import last 13 months of data from csv files*************


 		runListItems = csvToArrayOfHashes("yearlyRunListOps", "yearlyJobs", "yearlyMat")

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