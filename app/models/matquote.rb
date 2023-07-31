class Matquote < ApplicationRecord
	has_many :material_matquotes, dependent: :destroy
	has_many :materials, through: :material_matquotes
end
