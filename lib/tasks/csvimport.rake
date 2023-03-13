require 'csv'
require 'database_cleaner/active_record'
namespace :import do 
	task :csv => :environment do 


		jobsToUpdate = [] #array for jobs to check at the end for stats
		newOps = [] #empties array for new csv import
		CSV.foreach("app/assets/csv/yearlyRunListOps.csv", headers: true, :col_sep => "`") do |row| #imports initial csv and creates all arrays needed
			if row[0].to_s != "---"
				newOps << {
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
					User_Value: "",

					Material: "", 
		    		Mat_Vendor: "",
		    		Mat_Description: "",

		    		employee: "",
					dots: "",
					currentOp: "",
					matWaiting: ""
		    	}
		    	jobsToUpdate << row[0] #running list of jobs to update after import
		    end
		end
		newOps.each do |op| #parses through each item and merges with mat and jobs array
			if op[:status] == "O" || op[:status] == "S"
				schedSrt = op[:Sched_Start].to_s #reorganizes and prepares date field for sorting at end
				if schedSrt == "NULL" then schedSrt = "" end
				#merge Jobs data
				CSV.foreach("app/assets/csv/yearlyJobs.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
					if op[:Job] == row[0]
						schEnd = row[19].to_s #reorganize date field
						if schEnd == "NULL"
							schEnd = ""
						else
							year = schEnd[0..3]
							day = schEnd[8..9]
							month = schEnd[5..7]
							schEnd = "#{month}#{day}-#{year}"
						end
						op[:Customer] = row[1]
						op[:Order_Date] = row[2]
						op[:Part_Number] = row[3]
						op[:Rev] = row[4]
						op[:Description] = row[5]
						op[:Order_Quantity] = row[6]
						op[:Extra_Quantity] = row[7]
						op[:Pick_Quantity] = row[8]
						op[:Make_Quantity] = row[9]
						op[:Open_Operations] = row[10]
						op[:Completed_Quantity] = row[11]
						op[:Shipped_Quantity] = row[12]
						op[:FG_Transfer_Qty] = row[13]
						op[:In_Production_Quantity] = row[14]
						op[:Certs_Required] = row[15]
						op[:Act_Scrap_Quantity] = row[16]
						op[:Customer_PO] = row[17]
						op[:Customer_PO_LN] = row[18]
						op[:Job_Sched_End] = schEnd
						op[:Job_Sched_Start] = row[20]
						op[:Note_Text] = row[21] 
						op[:Released_Date] = row[22]
						op[:User_Value] = row[23]
						break
					end
				end
				#merge material data
				CSV.foreach("app/assets/csv/yearlyMat.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
					if op[:Job] == row[0]
						op[:Material] = row[1]
						op[:Mat_Vendor] = row[2]
						op[:Mat_Description] = row[3]
						break
					end
				end
				if op[:Material] == ""
					op[:Material] = "Customer Supplied"
				end

				#imports data previously saved from users into these jobs
				old = Runlist.where.not(employee: [nil, ""], matWaiting: [nil, "", false]) #saves what's altered to pass on later
				old.each do |data| 
					if data[:Job_Operation].to_s == op[:Job_Operation].to_s
						op[:employee] = data.employee
						op[:matWaiting] = data.matWaiting
						#material export includes the exact previous year of data for import
						break
					end
				end
			end
		end
		DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets runlists database table
		Runlist.import newOps
		#update operations with changed job info and material AFTER import 

		
		jobsToUpdate.uniq! #narrow down list of alterered Jobs to be unique
		jobsToUpdate.each do |opJob|
			jobs = Runlist.where(Job: opJob)
			jobs = jobs.sort_by { |a| a.Sequence }
			#binding.pry
			@found = false
			@foundMatWaiting = false
			@matCancel = false
			#binding.pry
			jobs.each do |op|
				#puts op.Sequence
				#calculate current location
				if @found == true
						op.currentOp = @foundOp
				else
					if op.status == "O" || op.status == "S"
						@foundOp = op.WC_Vendor
						op.currentOp  = @foundOp
						@found = true
					end
				end
				#Calculate if material pending should be turned off
				if @matCancel == true
					op.matWaiting = false
				else
					if op.WC_Vendor == "A-SAW" && op.status == "C"
						@matCancel = true
						op.matWaiting = false
					end
					if op.WC_Vendor == "IN" && op.status == "C"
						@matCancel = true
						op.matWaiting = false
					end
				end
				#calculate if material is pending
				if @foundMatWaiting == true
					op.matWaiting = true
				else
					if op.status == "O" && op.WC_Vendor == "IN"
						@foundMatWaiting = true
						op.matWaiting = true
					end
				end
				op.save #Saves the new currentop value if it's different
			end
		end
		CSV.foreach("app/assets/csv/yearlyUserValues.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			#User_Value: row[0],
			#dots: row[1]
			if row[0] != nil
				dot = row[1].to_s.upcase
				ops = Runlist.where(User_Value: row[0])
				puts ops
				ops.each do |op|
					case dot
						when "O"
							op.dots = 1
						when "0"
							op.dots = 1
						when "1"
							op.dots = 1
						when "OO"
							op.dots = 2
						when "00"
							op.dots = 2
						when "2"
							op.dots = 2
						when "OOO"
							op.dots = 3
						when "000"
							op.dots = 3
						when "3"
							op.dots = 3
					end
					op.save
				end
			end
		end

    end
end