class CreateMillinginvs < ActiveRecord::Migration[7.0]
  def change
    create_table :millinginvs do |t|
      t.string :part_number
      t.string :description
      t.integer :to_take
      t.integer :balance
      t.integer :minumum
      t.string :location
      t.string :vendor
      t.string :buyer
      t.string :toolinfo
      t.string :last_received
      t.string :last_email
      t.string :employee
      t.integer :hardwareid
      t.string :status
      t.string :orderdate
      t.integer :to_add

      t.timestamps
    end
    add_index :millinginvs, :hardwareid
  end
end
