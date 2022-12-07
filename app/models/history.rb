class History < ApplicationRecord 
	belongs_to :turninginv
	belongs_to :millinginv
	# attr_accessor :hnew_balance, :hlast_email, :checkedin, :checkedout, :hpart_number
	
end
