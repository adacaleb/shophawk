class AddUserValueToRunlists < ActiveRecord::Migration[7.0]
  def change
    add_column :runlists, :User_Value, :string
    add_index :runlists, :User_Value
  end
end
