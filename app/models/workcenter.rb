class Workcenter < ApplicationRecord
	#has_and_belongs_to_many :departments
	#belongs_to :department
	has_many :department_workcenters
	has_many :departments, through: :department_workcenters
end
