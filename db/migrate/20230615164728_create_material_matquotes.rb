class CreateMaterialMatquotes < ActiveRecord::Migration[7.0]
  def change
    create_table :material_matquotes do |t|
      t.references :material, null: false, foreign_key: true
      t.references :matquote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
