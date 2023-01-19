class Runlist < ApplicationRecord
require 'csv'
require 'database_cleaner/active_record'

	def self.importcsv
		DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets ID's
		items = []
		i = -1
	    CSV.foreach('app/assets/csv/runListOps.csv', headers: true) do |row|
			if row[1] && row[0] != "Dave H" && row[0] != "Greg V" && row[0] != "BRENT" && row[0] != "Caleb H" && row[0] != "Mike K"
				items << {
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
			      	i = i + 1

		    end
		end

#		puts items[2][:Job]
#		frank = 2
#		items[frank][:Job] = "test"
#		puts items[8][:Released_Date]
#		puts i



#If function is only seeing 1 job that matches up. Need to troubleshoot, but looking good otherwise.
		c = 0
		CSV.foreach('app/assets/csv/tempjobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true) do |row|
			if row[0] == items[c][:Job] && row[0] != "Dave H" && row[0] != "Greg V" && row[0] != "BRENT" && row[0] != "Caleb H" && row[0] != "Mike K"
				#items[c][:Customer] = row[2]
#				items[c][:Order_Date] = row[2]
#				items[c][:Part_Number] = row[3]
#				items[c][:Rev] = row[4]
#				items[c][:Description] = row[5]
#				items[c][:Order_Quantity] = row[6]
#				items[c][:Extra_Quantity] = row[7]
#				items[c][:Pick_Quantity] = row[8]
#				items[c][:Make_Quantity] = row[9]
#				items[c][:Open_Operations] = row[10]
#				items[c][:Completed_Quantity] = row[11]
#				items[c][:Shipped_Quantity] = row[12]
#				items[c][:FG_Transfer_Qty] = row[13]
#				items[c][:In_Production_Quantity] = row[14]
#				items[c][:Certs_Required] = row[15]
#				items[c][:Act_Scrap_Quantity] = row[16]
#				items[c][:Customer_PO] = row[17]
#				items[c][:Customer_PO_LN] = row[18]
#				items[c][:Job_Sched_End] = row[19]
#				items[c][:Job_Sched_Start] = row[20]
#				items[c][:Note_Text] = row[21] 
#				items[c][:Released_Date] = row[22]
				puts row[0]
			end
			c = c + 1
		end
		#puts items[100][:Customer]
		#Runlist.import items

	end

end


#	      	CSV.foreach('app/assets/csv/tempjobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true) do |row|
#				if item[0] == rowtwo[0]
#					items << {
# => 					items[] Customer: row[1], 
#						Order_Date: row[2], 
#						Part_Number: row[3], 
#						Rev: row[4], 
#						Description: row[5], 
#						Order_Quantity: row[6], 
#						Extra_Quantity: row[7], 
#						Pick_Quantity: row[8], 
#						Make_Quantity: row[9],
#						Open_Operations: row[10], 
#						Completed_Quantity: row[11], 
#						Shipped_Quantity: row[12], 
#						FG_Transfer_Qty: row[13], 
#						In_Production_Quantity: row[14], 
#						Certs_Required: row[15], 
#						Act_Scrap_Quantity: row[16], 
#						Customer_PO: row[17], 
#						Customer_PO_LN: row[18], 
#						Job_Sched_End: row[19], 
#						Job_Sched_Start: row[20], 
#						Note_Text: row[21], 
#						Released_Date: row[22]
#					}
#					break
#				end
#			end
#		end
#		items.each do |item|
#				CSV.foreach('app/assets/csv/tempmat.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true) do |rowthree|
#					if item[0] == rowthree[0]
#						items << {
#					      	Material: rowthree[1], 
#					      	Mat_Vendor: rowthree[2],
#					      	Mat_Description: rowthree[3]
#					    }
#					    break
#				    end
#				end
#		end
