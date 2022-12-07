class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.integer :hnew_balance
      t.string :hlast_email
      t.integer :checkedin
      t.integer :checkedout
      t.string :hpart_number
      t.integer :turninginv_id

      t.timestamps
    end
    add_index :histories, :turninginv_id
  end
end
