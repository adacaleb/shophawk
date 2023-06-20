class Material < ApplicationRecord
	has_many :material_matquotes
	has_many :matquote, through: :material_matquotes
end
