class AddSaturdayToSlideshows < ActiveRecord::Migration[7.0]
  def change
    add_column :slideshows, :saturday, :boolean
    add_column :slideshows, :nextSaturday, :boolean
  end
end
