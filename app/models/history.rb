class History < ApplicationRecord 
	belongs_to :turninginv, optional: true
	belongs_to :millinginv, optional: true
	# attr_accessor :hnew_balance, :hlast_email, :checkedin, :checkedout, :hpart_number
	
end
