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
		if params[:archive] == true #archives all open matquotes to the DB to no longer show up in current quotes list. 
			puts "in archive"
			@mats = Material.includes(:matquotes).where(matquotes: {archived: nil})
			@mats.each do |mat|
				mat.matquotes.each do |q|
					q.archived = true
					q.save
				end
			end
			@mats = Material.where(needOrder: true)
			@mats.each do |mat|
				mat.needOrder = false
				mat.save
			end
		end
	end

	def currentQuotes #loads all quotes not archived
		index
		puts "1"
		@toOrder = Material.where(needOrder: true) #General material needed to be ordered
		sizeFound = 0
		lenghtUsed = 0
		@orderedAmount = []
		@toOrder.sort
		@toOrder.each do |mat| #calc total ft used last year for each material needed to be ordered
			@matqs = mat.matquotes.where(archived: true)
			@matqs.each do |q|
				lenghtUsed = lenghtUsed + q.length
			end
			@orderedAmount << lenghtUsed
		end
		puts "2"

		if params[:size]
			@mat = params[:mat]
			@size = params[:size]
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
			@matquotes, @averageCost, @sellCost, @ftUsed, @cost_per_inch = getquotes(@mat, @size)
			respond_to do |format|
				format.turbo_stream
			end
		else
			@matSelect = {prompt: "Select Material"}
			@sizeSelect = {prompt: "Select Size"}
		end
		puts "3"
		if params[:archiveid] #saves the clicked archive button to the DB to no longer show up in current quotes list. 
			@material = Material.includes(:matquotes).where(matquotes: {id: params[:archiveid]})
			@material.each do |mat|
				mat.matquotes.each do |q|
					q.archived = true
					q.save
				end
			end
		end
		puts "4" #working, now need to get turboframe to update properly when finished
		if params[:archiveMatId]
			@material = Material.includes(:matquotes).where(id: params[:archiveMatId], matquotes: {archived: nil})
			if @material
				puts "5"
				@material.each do |mat|
					mat.matquotes.each do |q|
						q.archived = true
						q.save
					end
				end
			end
			puts "6"
			@material = Material.find_by(id: params[:archiveMatId])
			@material.needOrder = false
			@material.save
			redirect_to "/materials/currentQuotes", { responseKind: "turbo-stream"}
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
			@materialType = @materialQuote.materialType
			puts @materialType

			@matquotes = @materialQuote.matquotes.where(ordered: true)
			i = 0
			@weightedAverage = 0
			@ftUsed = 0
			@prices = []
			@lengths = []
			@matquotes.each do |mat|
				if mat.created_at < d #only calculates average for purchases made within last 12 months
					i = i + 1
					#@averageCost = @averageCost + mat.price
					@ftUsed = @ftUsed + mat.length.to_f

					@prices << mat.price.to_f
					@lengths << mat.length.to_f
				end
			end
			@weightedAverage = weightedAverage(@prices, @lengths, i)
			@sellCost = ((@weightedAverage * 1.2) * 4.0).ceil() / 4.0 #rounds up to nearest quarter
		else 
			@matquotes = nil
			@materialType = "Steel/Iron"
			@weightedAverage = 0
			@sellCost = 0
			@ftUsed = 0
		end
		@ftUsed = @ftUsed.round(2)
		@matquotes = @matquotes.reverse #puts most recent at top of tables
		specific_weight = metal_specific_weight(@materialType)
		weight_per_inch = weight_per_inch(size, specific_weight)
		puts weight_per_inch
		@cost_per_inch = (weight_per_inch.to_f * @sellCost).round(2)
		return @matquotes, @weightedAverage, @sellCost, @ftUsed, @cost_per_inch
	end

	def weight_per_inch(size, specific_weight)
  		((size.to_f**2 * 3.14159) * specific_weight) / 4.0
	end

	def metal_specific_weight(metal)
		puts metal
		case metal.downcase
		when "steel/iron"
			0.283
		 when "aluminum"
			0.098
		when "brass/bronze"
			0.307
		when "stainless"
			0.289
		when "nylon"
			0.045
		when "peek"
			0.052
		end
	end

	def weightedAverage(prices, lengths, count)
		i = 0
		weights = []
		while i < count
			weights << prices[i].to_f * lengths[i].to_f
			i = i + 1
		end
		weightSum = 0
		weights.each do |a|
			weightSum = weightSum + a
		end
		totalLength = 0
		lengths.each do |a|
			totalLength = totalLength + a
		end
		if totalLength != 0 #prevents errors if nothing to calculate
			average = weightSum / totalLength
		else 
			average = 0
		end
		return average
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

	def assignNeedOrder
		mat = params[:mat]
		size = params[:size]
		@materialQuote = Material.find_by(mat: mat, size: size)
		if @materialQuote.needOrder != true
			@materialQuote.needOrder = true
			@materialQuote.save
		end
		redirect_to "/materials/currentQuotes?mat=#{mat}&size=#{size}", { responseKind: "turbo-stream"}
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
			@material.needOrder = true
			if material_params[:matquotes][:price] != "" #only builds object if there's a price entered
				@newMat = @material.matquotes.build(material_params[:matquotes]) #saves build as an object that can be changed before saving
				if material_params[:matquotes][:ordered] == "1"
					@newMat.archived = true #sets true if the material was ordered to not show up in active quotes page
				end
				case @newMat.vendor.to_s.downcase #shortcuts for material vendors
				when "a"
					@newMat.vendor = "Alro"
				when "c"
					@newMat.vendor = "Castle"
				when "f"
					@newMat.vendor = "Farmers"
				when "e"
					@newMat.vendor = "Emj"
				when "d"
					@newMat.vendor = "Durabar"
				end
				@newMat.vendor = @newMat.vendor.titleize
				if @newMat.length != nil
					@newMat.length = @newMat.length.to_f / 12
					@newMat.length = @newMat.length.round(2)
				end
			end
			@material.save
			mat = @material.mat.gsub("#", "%23") #subsittute number sign for encoding of number sign to pass through GET request
			puts mat
			size = @material.size
			redirect_to "/materials/currentQuotes?mat=#{mat}&size=#{size}", { responseKind: "turbo-stream"}
		else #makes a new material if none is found.
			if material_params[:size] != "" #makes sure there's an entry before saving.
				@material = Material.new(material_params)
				@material.needOrder = true
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
		params.require(:material).permit(:id, :mat, :size, :materialType, :needOrder, :qtyNeeded, matquotes: [:vendor, :price, :length, :ordered, :sawcut, :additionalCost, :comment, :archived])
	end

end