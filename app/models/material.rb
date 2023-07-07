class Material < ApplicationRecord
	has_many :material_matquotes
	has_many :matquotes, through: :material_matquotes, dependent: :delete_all

	def matquotes_attributes=(matquotes_attributes) #used to save attributes to a materail type
		matquotes_attributes.each do |i, matquotes_attributes|
			self.matquotes.build(matquotes_attributes)
		end
	end

end
