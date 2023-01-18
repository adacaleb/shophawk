class CreateTempmats < ActiveRecord::Migration[7.0]
  def change
    create_table :tempmats do |t|
      t.string :Job
      t.string :Material
      t.string :Vendor
      t.string :Description

      t.timestamps
    end
  end
end
