class AddNumberOfCheckoutsToMillinginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :millinginvs, :number_of_checkouts, :integer
  end
end
