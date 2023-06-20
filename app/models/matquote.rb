class Matquote < ApplicationRecord
	has_many :material_matquotes
	has_many :materials, through: :material_matquotes
end
