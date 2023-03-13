class CreateDepartmentAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :department_assignments do |t|
      t.references :department, null: false, foreign_key: true
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
