class CreateTempjobs < ActiveRecord::Migration[7.0]
  def change
    create_table :tempjobs do |t|
      t.string :Job
      t.string :Customer
      t.string :Order_Date
      t.string :Part_Number
      t.string :Rev
      t.string :Description
      t.integer :Order_Quantity
      t.integer :Extra_Quantity
      t.integer :Pick_Quantity
      t.integer :Make_Quantity
      t.integer :Open_Operations
      t.integer :Completed_Quantity
      t.integer :Shipped_Quantity
      t.integer :FG_Transfer_Qty
      t.integer :In_Production_Quantity
      t.boolean :Certs_Required
      t.integer :Act_Scrap_Quantity
      t.string :Customer_PO
      t.string :Customer_PO_LN
      t.string :Sched_End
      t.string :Sched_Start
      t.string :Note_Text
      t.string :Released_Date

      t.timestamps
    end
  end
end
