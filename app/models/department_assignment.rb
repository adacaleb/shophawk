class DepartmentAssignment < ApplicationRecord
  belongs_to :department
  belongs_to :assignment
end
