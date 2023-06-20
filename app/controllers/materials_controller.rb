class MaterialsController < ApplicationController
	before_action :set_material, only: [ :show, :edit, :update, :destroy ]

	def index
		@materials = Material.all
		@material = Material.new
		@matNames = []
		@materials.each do |mat|
			@matNames << mat.mat
		end
		@matNames.uniq!
		@matSizes = [] #empty, will populate when a material is selected with JS controller + turbo-stream
	end

	def matsizes
		@target = params[:target]
		@materials = Material.where(mat: params[:mat])
		@matSizes = []
		@materials.each do |mat|
			@matSizes << mat.size
		end
		@matSizes.uniq!
		@size = @matSizes[0] #grabs first size to render for turbo-stream load of material history
		respond_to do |format|
			format.turbo_stream
		end
	end

	def matdata
		@size = params[:size] #grabs first size to render for turbo-stream load of material history

		respond_to do |format|
			format.turbo_stream
		end
	end

	def show
		@material = Material.find(params[:id])
	  #render json: @material, include: [:material_matquotes, :quotes]
	  redirect_to materials_url(@materials)
	end

	def edit
	end

	def create
		@material = Material.new(material_params)
		if @material.save
			redirect_to materials_url(@materials)
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
		puts params.inspect
		params.require(:material).permit(:id, :mat, :size)
	end

end
