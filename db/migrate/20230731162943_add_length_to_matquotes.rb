class AddLengthToMatquotes < ActiveRecord::Migration[7.0]
  def change
    add_column :matquotes, :length, :float
  end
end
