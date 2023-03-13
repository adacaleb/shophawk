class CreateDepartmentWorkcenters < ActiveRecord::Migration[7.0]
  def change
    create_table :department_workcenters do |t|
      t.references :department, null: false, foreign_key: true
      t.references :workcenter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
