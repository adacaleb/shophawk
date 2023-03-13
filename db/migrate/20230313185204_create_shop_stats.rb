class CreateShopStats < ActiveRecord::Migration[7.0]
  def change
    create_table :shop_stats do |t|
      t.integer :missedStarts
      t.integer :missedShips
      t.integer :scrap
      t.integer :totalJobs
      t.integer :totalRevenue
      t.integer :sixWeekRevenue
      t.integer :newTravelors

      t.timestamps
    end
  end
end
