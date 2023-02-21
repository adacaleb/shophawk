class Runlist < ApplicationRecord
#	has_many :departments, through: :department_workcenters
#	has_many :department_workcenters, through: :workcenter
require 'csv'
require 'database_cleaner/active_record'
#The CSV Import code is running as a rake task save in /lib/tasks/csvimport.  It's then ran via a .bat file on the desktop "csvimport.bat", and ran via the windows task scheduler every 5 minutes
	
end