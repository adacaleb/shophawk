class CreateMatquotes < ActiveRecord::Migration[7.0]
  def change
    create_table :matquotes do |t|
      t.string :vendor
      t.float :price
      t.boolean :ordered
      t.boolean :sawcut
      t.float :additionalCost
      t.string :comment

      t.timestamps
    end
  end
end
