class ChartsController < ApplicationController
	require 'csv'
	require 'date'

	def total_jobs
		jobs = self.dailyJobs(10)
		#puts json: Runlist.group_by_day(:created_at, last: 10).count
		render json: jobs
	end


	def dailyJobs(days)
		#jobs = Runlist.where("created_at > ?", Date.today - days)
		puts Date.today

		#lastJob = 0
		jobs = []
		jobsPerDay = []
		lastDate = Date.today - 1000
		dailyCount = 0
		count = 0
		CSV.foreach("app/assets/csv/yearlyJobs.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			if row[22].to_s.include?("---") || row[22] == "NULL" || row[22] == nil
			else
				#puts row[22]
				#puts row[22][0..9].to_date
				date = row[22][0..9].to_date
				#puts date
				#row[22] is the Released_Date field for each job
				if date <= Date.today - 180 #if out of range of date parameter passed in
					#break
				else
					jobs << {job: row[0], date: date}
				end
				#puts date, dailyCount
			end
		end
		#puts jobs
		firstLoop = true
		jobs = jobs.sort_by { |a| a[:date] }
		jobs.reverse!
		jobs.each do |job|
			#puts job
			if count < days
				if job[:date] == lastDate
					dailyCount = dailyCount + 1
					lastDate = job[:date]
				else 
					if firstLoop == false
						date = self.dateFormat(lastDate)
						jobsPerDay << ["#{date}", "#{dailyCount}"]
						dailyCount = 1
						lastDate = job[:date]
						count = count + 1
					else
						firstLoop = false
						lastDate = job[:date]
					end
				end
			end
		end
		jobsPerDay.reverse!
		puts jobsPerDay.to_json
		return jobsPerDay.to_json
	end

	def whoDidJobs(days)
		CSV.foreach("app/assets/csv/yearlyJobs.csv", 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
			if row[22] < Date.today - days #if out of range of date parameter passed in
				break
			end
			op[:Note_Text] = row[21] 
			op[:Released_Date] = row[22]

		end
		return result
	end

	def dateFormat(lastDate)
		date = lastDate.to_s
		year = date[0..3]
		day = date[8..9]
		month = date[5..7]
		date = "#{month}#{day}-#{year}"
		return date
	end


end