  class CreateTurninginvs < ActiveRecord::Migration[7.0]
  def change
    create_table :turninginvs do |t|
      t.string :part_number
      t.string :description
      t.integer :to_take
      t.integer :balance
      t.integer :remaining
      t.integer :minumum
      t.string :location
      t.string :vendor
      t.string :buyer
      t.string :last_received
      t.string :last_email
      t.string :employee

      t.timestamps
    end
  end
end
