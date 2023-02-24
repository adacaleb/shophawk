class AddStartedToDepartments < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :started, :boolean
  end
end
