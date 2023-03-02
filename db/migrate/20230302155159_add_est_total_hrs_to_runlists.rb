class AddEstTotalHrsToRunlists < ActiveRecord::Migration[7.0]
  def change
    add_column :runlists, :EstTotalHrs, :string
  end
end
