class Turninginv < ApplicationRecord
has_many :histories #, dependent: :destroy 

before_save :fields_check
before_save :update_balance
after_save :create_history
after_destroy :destroy_histories

require 'time'


	def restock_check
		@old_balance = balance
	end


	def fields_check #sets variables if they are nil or need initiating
		self.number_of_checkouts = 0 if self.number_of_checkouts == nil
		self.balance = 0 if self.balance == nil
		self.minumum = 0 if self.minumum == nil
		@old_balance = 0 if @old_balance == nil
	end

	def update_balance

		if self.to_take.to_i > 0 || self.to_take.to_i < 0 || self.to_add.to_i > 0 #if to_take is zero, it skips to make incart/ordred button work right
			current_time = Time.now
		    @time = current_time.strftime("%m/%d/%Y at %H:%M %P")

			if to_take.to_i > 0 #if checkout material
				@check_out = to_take.to_i
				@check_in = nil
				self.number_of_checkouts += 1
			end
			if to_add.to_i > 0 #if checkin material
				@check_out = nil
				@check_in = to_add.to_i
				current_time = Time.now
		    	self.last_received = @time

			end
			self.balance = balance.to_i - to_take.to_i
			self.balance = balance.to_i + to_add.to_i
			if self.balance < 0
	      	 self.balance = 0	      	
			end
		    if balance > @old_balance  #if qty is increased, counts as tool received 
		    	@check_out =  nil
		    	@check_in = balance - @old_balance
		    end
		    @old_balance = 0
		    @time = nil
		    self.to_take = 0
		    self.to_add = 0
		    if balance >= minumum
				self.status = "stocked"
			elsif balance < minumum
				if status != "In Cart" || status != "Ordered"
					self.status = "Needs Restock"
				end
			end
		end
	end

	def create_history
		if @check_in == nil && @check_out == nil #prevents a history from being made unless items added or taken. 
		else
		History.create(hnew_balance: balance,
			hlast_email: nil,
			checkedout: @check_out,
			checkedin: @check_in,
			hpart_number: part_number,
			date: @time,
			turninginv_id: self.id)
		end
	end

private

	def destroy_histories #runs when delete tool is ran. deletes all associated tool history
		self.histories.destroy_all
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