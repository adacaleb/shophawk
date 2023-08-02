class MatquotesController < ApplicationController


	def destroy
		@matquote = Matquote.find(params[:id])
		@matId = @matquote.materials[0].id
		puts @matId
		puts @matquote.archived
		if @matquote.archived == true
			if @matquote.destroy
				redirect_to "/materails/#{@matId}/edit"
			end
		else
			if @matquote.destroy
				redirect_to "/materials/currentQuotes"
			end
		end
	end

end
