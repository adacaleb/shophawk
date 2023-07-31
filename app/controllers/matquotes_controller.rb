class MatquotesController < ApplicationController


	def destroy
		@matquote = Matquote.find(params[:id])
		if @matquote.destroy
			redirect_to "/materials/currentQuotes"
		end
	end

end
