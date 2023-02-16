class DepartmentWorkcenter < ApplicationRecord
  belongs_to :department
  belongs_to :workcenter
end
