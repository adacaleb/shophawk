class AddMaterialTypeToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :materialType, :string
  end
end
