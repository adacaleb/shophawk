class MaterialsController < ApplicationController
	require 'date'
	before_action :set_material, only: [ :show, :edit, :update, :destroy ]

	def index

		@materials = Material.all
		@material = Material.new
		@material.matquotes.build

		@matNames = []
		@materials.each do |mat|
			@matNames << mat.mat
		end
		@matNames.uniq!
		@matNames.sort!
		@matSizes = [] #empty, will populate when a material is selected with JS controller + turbo-stream
		@matSelect = {prompt: "Select Material"}
		@sizeSelect = {prompt: "Select Size"}

		#If "archive == true in params when page loads, it archives all open matquotes"
		if params[:archive] == "true" #archives all open matquotes to the DB to no longer show up in current quotes list. 
			@mats = Material.includes(:matquotes).where(matquotes: {archived: nil})
			@mats.each do |mat|
				mat.matquotes.each do |q|
					q.archived = true
					q.save
				end
			end
		end
	end

	def newquote #turbo_stream function for when submitting a new quote order
		@materials = Material.all
		@material = Material.new
		@material.matquotes.build

		@matNames = []
		@materials.each do |mat|
			@matNames << mat.mat
		end
		@matNames.uniq!
		@matNames.sort!
		@matSizes = [] #empty, will populate when a material is selected with JS controller + turbo-stream


		#If "archive == true in params when page loads, it archives all open matquotes"
		if params[:archive] == "true" #archives all open matquotes to the DB to no longer show up in current quotes list. 
			@mats = Material.includes(:matquotes).where(matquotes: {archived: nil})
			@mats.each do |mat|
				mat.matquotes.each do |q|
					q.archived = true
					q.save
				end
			end
		end

		sizeFound = 0
		@mat = params[:mat]
		@size = params[:size]
		@target = params[:target]
		@matSelect = {:selected => @mat}
		@sizeSelect = {:selected => @size}
		@materials = Material.where(mat: params[:mat])
		@matSizes = []
		@materials.each do |mat| #saves all sizes found for materail to render in size select box
			@matSizes << mat.size
			if mat.size == @size
				sizeFound = 1
			end
		end
		@matSizes.uniq!
		@matSizes = @matSizes.sort_by { |num| num.to_s.to_f }
		if sizeFound == 0 #if no matching size when changing material type or 1st load of page, sets it to first found size.
			@size = @matSizes[0].size
		end
		@matquotes, @averageCost, @sellCost, @ftUsed = getquotes(@mat, @size)
		respond_to do |format|
			format.turbo_stream
		end
	end

	def getquotes(mat, size) #sub routine that loads all ordered history for a material. 
		d = DateTime.now    #=> #<DateTime: 2018-02-20T15:39:44+01:00 ...>
		d << 4              #=> #<DateTime: 2017-10-20T15:39:44+01:00 ...>
		d.prev_month(12)     #=> #<DateTime: 2017-10-20T15:39:44+01:00 ...>	
		@materialQuote = Material.find_by(mat: mat, size: size)
		if @materialQuote != nil
			@matquotes = @materialQuote.matquotes.where(ordered: true)
			i = 0
			@averageCost = 0
			@ftUsed = 0
			@matquotes.each do |mat|
				if mat.created_at < d #only calculates average for purchases made within last 12 months
					i = i + 1
					@averageCost = @averageCost + mat.price
					@ftUsed = @ftUsed + mat.length.to_f
				end
			end
			if i > 0
				@averageCost = @averageCost / i
			end
			@sellCost = ((@averageCost * 1.2) * 4.0).ceil() / 4.0 #rounds up to nearest quarter

		else 
			@matquotes = nil
			@averageCost = 0
			@sellCost = 0
			@ftUsed = 0
		end
		@matquotes = @matquotes.reverse #puts most recent at top of tables
		return @matquotes, @averageCost, @sellCost, @ftUsed
	end

	def currentQuotes #loads all quotes not archived
		@materials = Material.includes(:matquotes).where(matquotes: {archived: nil})
		
		if params[:archiveid] #saves the clicked archive button to the DB to no longer show up in current quotes list. 
			@material = Material.includes(:matquotes).where(matquotes: {id: params[:archiveid]})
			@material.each do |mat|
				mat.matquotes.each do |q|
					q.archived = true
					q.save
				end
			end
		end
	end

	def matchange #Loads all ordered quotes from JS when a size is selected.
		sizeFound = 0
		@size = params[:size]
		@mat = params[:mat]
		@target = params[:target]
		@materials = Material.where(mat: params[:mat])
		@matSizes = []
		@materials.each do |mat| #saves all sizes found for materail to render in size select box
			@matSizes << mat.size
			if mat.size == @size
				sizeFound = 1
			end
		end
		@matSizes.uniq!
		@matSizes = @matSizes.sort_by { |num| num.to_s.to_f }
		if sizeFound == 0 #if no matching size when changing material type or 1st load of page, sets it to first found size.
				@size = @matSizes[0]
		end
		@matquotes, @averageCost, @sellCost, @ftUsed = getquotes(@mat, @size)
		respond_to do |format|
			format.turbo_stream
		end
	end

	def sizechange #Run from JS when a Material is selected
		@size = params[:size]
		@mat = params[:mat]
		@matquotes, @averageCost, @sellCost = getquotes(@mat, @size)
		respond_to do |format|
			format.turbo_stream
		end
	end

	def orderedCheckBox #toggles "ordered" status for material quote
		puts params[:id]
		@matquote = Matquote.find_by(id: params[:id])
		@matquote.ordered = !@matquote.ordered
		@matquote.save
	end

	def sawcutCheckBox #Toggles "Sawcut" when check box is selected for material quote
		puts params[:id]
		@matquote = Matquote.find_by(id: params[:id])
		puts @matquote.sawcut
		@matquote.sawcut = !@matquote.sawcut
		@matquote.save
		puts @matquote.sawcut
	end

	def show
	  @material = Material.find(params[:id])
	  #render json: @material, include: [:material_matquotes, :quotes]
	  redirect_to materials_url(@materials)
	end

	def edit
		@matquotes = @material.matquotes.all
		@matquotes = @matquotes.reverse
	end

	def create #Creates a new material/size or a new quote for a material/size depending on contents of params.
		@material = Material.find_by(mat: material_params[:mat], size: material_params[:size])
		if @material #if a material is found, it doesn't create a new one, but creates a matquote for that size found.
			if material_params[:matquotes_attributes]['0'][:price] != "" #only builds object if there's a price entered
				@newMat = @material.matquotes.build(material_params[:matquotes_attributes]['0']) #saves build as an object that can be changed before saving
				if material_params[:matquotes_attributes]['0'][:ordered] == "1"
					@newMat.archived = true #sets true if the material was ordered to not show up in active quotes page
				end
				@newMat.vendor = @newMat.vendor.titleize
				if @newMat.length != nil
					@newMat.length = @newMat.length.to_f / 12
					@newMat.length = @newMat.length.round(2)
				end
			end
			@material.save
		else #makes a new material if none is found.
			if material_params[:size] != "" #makes sure there's an entry before saving.
				@material = Material.new(material_params)
				if @material.save
					redirect_to materials_url(@materials)
				end
			end
		end
	end

	def update
		@material = Material.find(params[:id])
		@material.update(material_params)
		redirect_to materials_url(@materials)
	end

	def destroy
		if @material.destroy
			redirect_to materials_url(@materials)
		end
	end


	private 

	def set_material
		@material = Material.find(params[:id])
	end

	def material_params
		#puts params.inspect
		params.require(:material).permit(:id, :mat, :size, :matquotes, matquotes_attributes: [:vendor, :price, :length, :ordered, :sawcut, :additionalCost, :comment, :archived])
	end

end
