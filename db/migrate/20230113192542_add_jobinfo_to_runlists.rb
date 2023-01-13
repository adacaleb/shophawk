class AddJobinfoToRunlists < ActiveRecord::Migration[7.0]
  def change
    add_column :runlists, :Order_Date, :string
    add_column :runlists, :Part_Number, :string
    add_column :runlists, :Rev, :string
    add_column :runlists, :Order_Quantity, :integer
    add_column :runlists, :Extra_Quantity, :integer
    add_column :runlists, :Pick_Quantity, :integer
    add_column :runlists, :Make_Quantity, :integer
    add_column :runlists, :Open_Operations, :integer
    add_column :runlists, :Completed_Quantity, :integer
    add_column :runlists, :Shipped_Quantity, :integer
    add_column :runlists, :FG_Transfer_Qty, :integer
    add_column :runlists, :In_Production_Quantity, :integer
    add_column :runlists, :Certs_Required, :boolean
    add_column :runlists, :Act_Scrap_Quantity, :integer
    add_column :runlists, :Customer_PO, :string
  end
end
