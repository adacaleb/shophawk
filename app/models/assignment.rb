class Assignment < ApplicationRecord
	has_many :department_assignments, dependent: :delete_all #need 2nd part to delete all records when delete is clicked
	has_many :departments, through: :department_assignments
end
