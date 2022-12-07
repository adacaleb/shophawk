class AddHardwareidToTurninginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :turninginvs, :hardwareid, :integer
    add_index :turninginvs, :hardwareid
  end
end
