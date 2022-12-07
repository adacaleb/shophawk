class AddNumberOfCheckoutsToTurninginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :turninginvs, :number_of_checkouts, :integer
  end
end
