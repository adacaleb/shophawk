class Runlist < ApplicationRecord
require 'csv'
require 'database_cleaner/active_record'

	def self.importcsv
		DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets ID's
		runListItems = []
		CSV.foreach('app/assets/csv/runListOps.csv', headers: true, :col_sep => "`") do |row|
			runListItems << {
		      	Job: row[0], 
		      	Job_Operation: row[1], 
		      	WC_Vendor: row[2],
		      	Operation_Service: row[3],
		      	Vendor: row[4],
		      	Sched_Start: row[5],
		      	Sched_End: row[6],
			    Sequence: row[7],

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
		      	Mat_Description: ""
		      	}
		end
		jobs = []
		CSV.foreach('app/assets/csv/tempjobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
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
		runListItems.each do |items|
			jobs.each do |row|
				if items[:Job] == row[:Job] 
					items[:Customer] = row[:Customer]
					items[:Order_Date] = row[:Order_Date]
					items[:Part_Number] = row[:Part_Number]
					items[:Rev] = row[:Rev]
					items[:Description] = row[:Description]
					items[:Order_Quantity] = row[:Order_Quantity]
					items[:Extra_Quantity] = row[:Extra_Quantity]
					items[:Pick_Quantity] = row[:Pick_Quantity]
					items[:Make_Quantity] = row[:Make_Quantity]
					items[:Open_Operations] = row[:Open_Operations]
					items[:Completed_Quantity] = row[:Open_Operations]
					items[:Shipped_Quantity] = row[:Shipped_Quantity]
					items[:FG_Transfer_Qty] = row[:FG_Transfer_Qty]
					items[:In_Production_Quantity] = row[:In_Production_Quantity]
					items[:Certs_Required] = row[:Certs_Required]
					items[:Act_Scrap_Quantity] = row[:Act_Scrap_Quantity]
					items[:Customer_PO] = row[:Customer_PO]
					items[:Customer_PO_LN] = row[:Customer_PO_LN]
					items[:Job_Sched_End] = row[:Job_Sched_End]
					items[:Job_Sched_Start] = row[:Job_Sched_Start]
					items[:Note_Text] = row[:Note_Text] 
					items[:Released_Date] = row[:Released_Date]
					break
				end
			end
		end
		mat = []
		CSV.foreach('app/assets/csv/tempmat.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			mat << {
				Job: row[0],
				Material: row[1], 
		      	Mat_Vendor: row[2],
		      	Mat_Description: row[3]
				}
		end		
		runListItems.each do |items|
			mat.each do |row|
				if items[:Job] == row[:Job] 
					items[:Material] = row[:Material]
					items[:Mat_Vendor] = row[:Mat_Vendor]
					items[:Mat_Description] = row[:Mat_Description]
					break
				end
			end
		end
		Runlist.import runListItems
	end

end