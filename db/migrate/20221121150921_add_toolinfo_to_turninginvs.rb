class AddToolinfoToTurninginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :turninginvs, :toolinfo, :string
  end
end
