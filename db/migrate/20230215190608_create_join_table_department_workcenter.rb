class CreateJoinTableDepartmentWorkcenter < ActiveRecord::Migration[7.0]
  def change
    create_join_table :departments, :workcenters do |t|
      # t.index [:department_id, :workcenter_id]
      # t.index [:workcenter_id, :department_id]
    end
  end
end
