class CreateRunlists < ActiveRecord::Migration[7.0]
  def change
    create_table :runlists do |t|
      t.string :Job
      t.integer :Job_Operation
      t.string :WC_Vendor
      t.string :Operation_Service
      t.string :Vendor
      t.string :Sched_Start
      t.string :Sched_End
      t.integer :Sequence
      t.string :operator
      t.boolean :materialWaiting
      t.integer :dots
      t.string :customer
      t.integer :quantity
      t.string :material
      t.string :description
      t.string :currentLocation

      t.timestamps
    end
  end
end
