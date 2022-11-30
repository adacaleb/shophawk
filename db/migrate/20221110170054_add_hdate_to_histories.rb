class AddHdateToHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :histories, :date, :string
  end
end
