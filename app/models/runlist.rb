class Runlist < ApplicationRecord
require 'csv'
require 'database_cleaner/active_record'



#def self.import_from_csv
#  runlist = CSV.foreach('assets/csv/runListOps.csv', headers: true).map do |row|                                                                 
#  { 
#    id: row[0].to_i,
#    Job: row['Job'],
#    Job_Operation: row['Job_Operation'],
#    WC_Vendor: row['WC_Vendor'],
#    Operation_Service: row['Operation_Service'],
#    Vendor: row['Vendor'],
#    Sched_Start: row['Sched_Start'],
#    Sched_End: row['Sched_End'],
#    Sequence: row['Sequence']
#
#  }
#  end
#  Runlist.insert_all(runlist)
#end

	def self.importjobops

		DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets ID's
	 	items = []
	    CSV.foreach('app/assets/csv/runListOps.csv', headers: true) do |row|
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
	   Runlist.import items
	   
	end
end
