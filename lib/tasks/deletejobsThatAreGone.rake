require 'csv'
require 'database_cleaner/active_record'
require 'date'
#this task looks at every job from the past year and makes an array of hashes for each of them with the current total amount of operations (sequence number)
#It just cross references that with the shophawk database. if any extra operations exist, it deletes them from the shophawk DB
namespace :delete do 
	task :jobsThatAreGone => :environment do 
		date = Date.today - 365
		lastJob = 0
		started = 0
		sequence = 0
		totalOpsPerJob = []
		CSV.foreach("app/assets/csv/yearlyRunListOps.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			if row[5] == "-----------" || row[5] == "NULL" || row[5] == nil
			else
				startDate = row[5]
				startDate = startDate[0..9]
				startDate = Date.strptime(startDate, '%Y-%m-%d')
				
				#puts startDate
				if startDate > date #stops the loop if looking past the defined "date" above. 
			    else
			    	break
			    end
				if started == 0 #allows calculations of the first row
					sequence = row[7].to_i
					started = 1
				end
				
				if lastJob == row[0] || lastJob == 0
					lastJob = row[0]
				else
					#sequence = sequence + 1
					totalOpsPerJob << { job: lastJob, sequence: sequence }
					lastJob = row[0]
				end
				sequence = row[7].to_i

	#			Job: row[0],
	#	    	Job_Operation: row[1],
	#	    	Operation_Service: row[3],
	#	    	Vendor: row[4],
	#	    	Sched_Start: row[5],
	#	    	Sched_End: row[6],
	#		    Sequence: row[7],
	#			status: row[8],
	#			EstTotalHrs: row[9]
			end
		end
		puts totalOpsPerJob.count
		totalOpsPerJob.each do |job|
			jobs = Runlist.where(Job: job[:job])
			jobs = jobs.sort_by { |a| a.Sequence }
			#puts job[:job]
			#puts job[:sequence]
			jobs.each do |a|
				if a.Sequence <= job[:sequence] #delete any operations that are outside sequence detected from Jobboss
					#puts "Yes"
				else 
					puts a.Job
					a.delete
				end
			end
		end

	end
end