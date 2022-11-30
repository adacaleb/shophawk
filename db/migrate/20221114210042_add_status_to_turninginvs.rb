class AddStatusToTurninginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :turninginvs, :status, :string
    add_column :turninginvs, :orderdate, :string
  end
end
