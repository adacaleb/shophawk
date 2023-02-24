class Runlist < ApplicationRecord
#	has_many :departments, through: :department_workcenters
#	has_many :department_workcenters, through: :workcenter
require 'csv'
require 'database_cleaner/active_record'
#The CSV Import code is running as a rake task save in /lib/tasks/csvimport.  It's then ran via a .bat file on the desktop "csvimport.bat", and ran via the windows task scheduler every 5 minutes
	
	def self.getDepartments
		#load and sort departments for select box
	    @departments = []
	    @d = Department.all
	    @d.each do |a|
	      @departments << a.department
	    end
	    return @departments.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 }
	end

	def self.getWorkcenters
		#Load and sort workcenters for select box
		@workCenters = [] #define empty array
    	@wcs = Workcenter.all
    	@wcs.each do |a| 
      		@workCenters << a.workCenter #creates array of just workcenters 
	    end
	    @workCenters.uniq! #narrows down array to only be unique workcenters
	    return @workCenters.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 } #sorts workcenter alphbetically
	end 

	def self.loadOperations(workCentersToShow, isDepartment, showStarted)
		show = []
		if showStarted == true #sets variable to compare against to render started jobs or not based on status
			show = ["S", "O"]
		else
			show = ["O"]
		end
		@operations = Runlist.where(WC_Vendor: workCentersToShow, status: show) 
	    @operations = @operations.sort { |a,b| (a.Sched_Start == b.Sched_Start) ? a.Job <=> b.Job : a.Sched_Start <=> b.Sched_Start } #sorts items by schedule start date, then job # within
	    if isDepartment == true
	    	@operations = @operations.sort { |a,b| (a.Sched_Start == b.Sched_Start) ? a.WC_Vendor <=> b.WC_Vendor : a.Sched_Start <=> b.Sched_Start } #sorts items by schedule start date, then job # within
	    end
	    @operations.each do |op| #sorts the date field to look correct for user
	      year = op.Sched_Start[0..3]
	      day = op.Sched_Start[8..9]
	      month = op.Sched_Start[5..7]
	      op.Sched_Start = "#{month}#{day}-#{year}"
	    end
	    return @operations
	end



	#the code that imports the CSV's from JObboss is in ~/lib/tasks/csvimport.rake
	
end