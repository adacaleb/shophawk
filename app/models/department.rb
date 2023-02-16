class Department < ApplicationRecord
	#has_and_belongs_to_many :workcenters
	has_many :department_workcenters
	has_many :workcenters, through: :department_workcenters
end
