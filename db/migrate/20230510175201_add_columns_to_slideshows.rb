class AddColumnsToSlideshows < ActiveRecord::Migration[7.0]
  def change
    add_column :slideshows, :saturdayO, :string
    add_column :slideshows, :saturdayC, :string
    add_column :slideshows, :nextSaturdayO, :string
    add_column :slideshows, :nextSaturdayC, :string
  end
end
