class CreateDepartmentassignments < ActiveRecord::Migration[7.0]
  def change
    create_table :departmentassignments do |t|
      t.string :departmentassignment

      t.timestamps
    end
  end
end
