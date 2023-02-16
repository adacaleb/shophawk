class Workcenter < ApplicationRecord
	has_and_belongs_to_many :departments
end
