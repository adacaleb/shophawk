class AddCapicityToDepartments < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :capacity, :float
  end
end
