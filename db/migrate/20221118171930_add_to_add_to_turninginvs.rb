class AddToAddToTurninginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :turninginvs, :to_add, :integer
  end
end
