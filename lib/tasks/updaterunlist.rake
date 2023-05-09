require 'csv'
require 'database_cleaner/active_record'
namespace :update do 
	task :runlist => :environment do 


		jobsToUpdate = []
		newOps = [] #empties array for new csv import
		CSV.foreach("app/assets/csv/runListOps.csv", headers: true, :col_sep => "`") do |row| #imports initial csv and creates all arrays needed
			op = Runlist.find_by(Job: row[0], Sequence: row[7]) #search by these to find and replace operations that get changed/replaced
			if op.present? #if record already exists in our DB, we just update the needed fields
				if op.Job_Operation != row[1] then op.Job_Operation = row[1] end
				if op.WC_Vendor != row[2] then op.WC_Vendor = row[2] end
				if op.Operation_Service != row[3] then op.Operation_Service = row[3] end
				if op.Vendor != row[4] then op.Vendor = row[4] end
				if op.Sched_Start != row[5] then op.Sched_Start = row[5] end
				if op.Sched_End != row[6] then op.Sched_End = row[6] end
				if op.Sequence != row[7] then op.Sequence = row[7] end
				if op.status != row[8] then op.status = row[8] end
				if op.EstTotalHrs != row[9] then op.EstTotalHrs = row[9] end
				jobsToUpdate << row[0] #running list of jobs to update after import
				op.save
			else #create array of hashes to add a new Operation to the Database
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
		end
		newOps.each do |op| #parses through each item and merges with mat and jobs array
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
		Runlist.import newOps
		#update operations with changed job info and material AFTER import 
		CSV.foreach("app/assets/csv/tempjobs.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			if row[0].to_s == nil || row[0].to_s == "" || row[0].to_s == "---"
			else
				jobs = Runlist.where(Job: row[0])
				if jobs.present? #if record already exists in our DB, we just update the needed fields
					jobs.each do |job|
						if job.Customer != row[1] then job.Customer = row[1] end
						if job.Order_Date != row[2] then job.Order_Date = row[2] end
						if job.Part_Number != row[3] then job.Part_Number = row[3] end
						if job.Rev != row[4] then job.Rev = row[4] end
						if job.Description != row[5] then job.Description = row[5] end
						if job.Order_Quantity != row[6] then job.Order_Quantity = row[6] end
						if job.Extra_Quantity != row[7] then job.Extra_Quantity = row[7] end
						if job.Pick_Quantity != row[8] then job.Pick_Quantity = row[8] end
						if job.Make_Quantity != row[9] then job.Make_Quantity = row[9] end
						if job.Open_Operations != row[10] then job.Open_Operations = row[10] end
						if job.Completed_Quantity != row[11] then job.Completed_Quantity = row[11] end
						if job.Shipped_Quantity != row[12] then job.Shipped_Quantity = row[12] end
						if job.FG_Transfer_Qty != row[13] then job.FG_Transfer_Qty = row[13] end
						if job.In_Production_Quantity != row[14] then job.In_Production_Quantity = row[14] end
						if job.Certs_Required != row[15] then job.Certs_Required = row[15] end
						if job.Act_Scrap_Quantity != row[16] then job.Act_Scrap_Quantity = row[16] end
						if job.Customer_PO != row[17] then job.Customer_PO = row[17] end
						if job.Customer_PO_LN != row[18] then job.Customer_PO_LN = row[18] end
						if job.Job_Sched_End != row[19] then job.Job_Sched_End = row[19] end
						if job.Job_Sched_Start != row[20] then job.Job_Sched_Start = row[20] end
						if job.Note_Text != row[21] then job.Note_Text = row[21] end
						if job.Released_Date != row[22] then job.Released_Date = row[22] end
						if job.User_Value != row[23] then job.User_Value = row[23] end
						jobsToUpdate << row[0] #running list of jobs to update after import
						job.save
					end
				end
			end
		end
		CSV.foreach("app/assets/csv/tempmat.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			if row[0].to_s == nil || row[0].to_s == "" || row[0].to_s == "---"
			else
				jobs = Runlist.where(Job: row[0])
				if jobs.present? #if record already exists in our DB, we just update the needed fields
					jobs.each do |job|
						if job.Material != row[1] then job.Material = row[1] end
						if job.Mat_Vendor != row[2] then job.Mat_Vendor = row[2] end
						if job.Mat_Description != row[3] then job.Mat_Description = row[3] end
						jobsToUpdate << row[0] #running list of jobs to update after import
						job.save
					end
				end
			end
		end
		jobsToUpdate.uniq! #narrow down list of alterered Jobs to be unique
		jobsToUpdate.each do |opJob|
			job = Runlist.where(Job: opJob)
			job = job.sort_by { |a| a.Sequence }
			#binding.pry
			@found = false
			@foundMatWaiting = false
			@matCancel = false
			#binding.pry
			job.each do |op|
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

		dotJobs = []
	    CSV.foreach("app/assets/csv/yearlyUserValues.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
	      if row[0] != nil
	        dot = row[1].to_s.upcase
	        ops = Runlist.where(User_Value: row[0])
	        #puts ops
	        ops.each do |op|
	          dotJobs << op.Job
	          break
	        end
	        ops.each do |op|
	          case dot
	            when nil
	              op.dots = nil 
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
	    @operations = Runlist.where(status: "O").where().not(dots: nil) #select operations with dots and open
	    checkJobs = []
	    @operations.each do |op|
	      if dotJobs.include? op.Job
	        #puts "yes"
	      else
	        #puts "no"
	        op.dots = nil #removes the unneeded dots from the job
	        op.save
	      end
	    end
		
	end
end