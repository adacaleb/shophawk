class Tempjob < ApplicationRecord
require 'csv'
require 'database_cleaner/active_record'

	def self.importjobs
		DatabaseCleaner.clean_with(:truncation, :only => %w[tempjobs]) #resets ID's
	 	items = []
			CSV.foreach('app/assets/csv/tempjobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true) do |row|
				if row[0] && row[0] != "Dave H" && row[0] != "Greg V" && row[0] != "BRENT" && row[0] != "Caleb H" && row[0] != "Mike K"
					items << {
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
						Sched_End: row[19], 
						Sched_Start: row[20], 
						Note_Text: row[21], 
						Released_Date: row[22]
					}
				end
			end
			Tempjob.import items
	end
end
