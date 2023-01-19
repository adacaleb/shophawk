class CreateTempops < ActiveRecord::Migration[7.0]
  def change
    create_table :tempops do |t|
      t.string :Job
      t.integer :Job_Operation
      t.string :WC_Vendor
      t.string :Operation_Service
      t.string :Vendor
      t.string :Sched_Start
      t.string :Sched_End
      t.integer :Sequence

      t.timestamps
    end
  end
end
