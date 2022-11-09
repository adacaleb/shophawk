class Turninginv < ApplicationRecord

	has_many :histories #, dependent: :destroy 
	accepts_nested_attributes_for :histories #enables saving history attributes from the parent turninginv model.


require 'time'

	def turninginv_id_assign 
		@turninginv_id = id
		update(turninginv_id:)
	end

	def restock_check
		@old_balance = balance
	end

	def update_balance
		@take = to_take
		@new_balance = balance.to_i - to_take.to_i
		if @new_balance < 0
	       @new_balance = 0
	    end
	    if balance > @old_balance  #if qty is increased, counts as tool received 
	    	current_time = Time.now
	    	last_received = current_time.strftime("%m/%d/%Y at %H:%M %P")
	    	update(last_received:)
	    end
	    update(balance: @new_balance, to_take: 0)
	end

	def make_history
		params = { turninginv: {
			posts_attributes: [
				{ hlast_email: nil },
				{ checkedout: nil },
				{ checkedin: 42 },
				{ hpart_number: part_number },
				{ turninginv_id: @turninginv_id }
			]
		}}
	end


end


#        @current_to_take = @turninginv.to_take.to_i     #this block updates the balance. need to save instance variables seperate, alter, then .save. 
#        @currentbalance = @turninginv.balance.to_i  
#        @new_balance = @currentbalance - @current_to_take
#        if @new_balance < 0
#          @new_balance = 0
#        end
#        @turninginv.balance = @new_balance
#        @turninginv.to_take = 0
#        @turninginv.save