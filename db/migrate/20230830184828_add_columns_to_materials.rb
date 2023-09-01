class AddColumnsToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :needOrder, :boolean
    add_column :materials, :qtyNeeded, :float
  end
end
