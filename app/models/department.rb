class Department < ApplicationRecord
	#has_and_belongs_to_many :workcenters
	has_many :department_workcenters, dependent: :delete_all #need 2nd part to delete all records when delete is clicked
	has_many :workcenters, through: :department_workcenters
	
	has_many :department_assignments, dependent: :delete_all
	has_many :assignments, through: :department_assignments
end
