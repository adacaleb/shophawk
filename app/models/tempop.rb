class Tempop < ApplicationRecord
require 'csv'
require 'database_cleaner/active_record'

	def self.importjobops
		DatabaseCleaner.clean_with(:truncation, :only => %w[tempops]) #resets ID's
		items = []

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
				    Sequence: row[7]
			      	}
		    end
	    end
   		Tempop.import items
	end
end
