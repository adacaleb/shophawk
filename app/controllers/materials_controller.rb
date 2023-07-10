class MaterialsController < ApplicationController
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
		@matSizes = [] #empty, will populate when a material is selected with JS controller + turbo-stream
	end

	def matsizes
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
		@matSizes.sort!
		if sizeFound == 0 #if no matching size when changing material type or 1st load of page, sets it to first found size.
			@size = @matSizes[0].size
		end
		@matquotes = getquotes(@mat, @size)
		respond_to do |format|
			format.turbo_stream
		end
	end

	def matdata #load all pricing history for the selected size and material
		@size = params[:size]
		@mat = params[:mat]
		@matquotes = getquotes(@mat, @size)
		respond_to do |format|
			format.turbo_stream
		end
	end

	def getquotes(mat, size)
		@material = Material.find_by(mat: mat, size: size)
		@matquotes = @material.matquotes
		return @matquotes
	end


	def show
	  @material = Material.find(params[:id])
	  #render json: @material, include: [:material_matquotes, :quotes]
	  redirect_to materials_url(@materials)
	end

	def edit
	end

	def create #Creates a new material/size or a new quote for a material/size depending on contents of params. 
		@material = Material.find_by(mat: material_params[:mat], size: material_params[:size])
		if @material #if a material is found, it doesn't create a new one.
			if material_params[:matquotes_attributes]['0'][:price] != "" #only builds object if there's a price entered
				@material.matquotes.build(material_params[:matquotes_attributes]['0']) #Builds a new matquote entry for found material and size
			end
		else #makes a new material if none is found.
			if material_params[:size] != "" #makes sure there's an entry before saving.
				@material = Material.new(material_params)
			end
		end
		if @material
			if @material.save
				redirect_to materials_url(@materials)
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
		params.require(:material).permit(:id, :mat, :size, matquotes_attributes: [:vendor, :price, :ordered, :sawcut, :additionalCost, :comment])
	end

end
