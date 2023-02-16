class CreateWorkcenters < ActiveRecord::Migration[7.0]
  def change
    create_table :workcenters do |t|
      t.string :workCenter
      
      t.timestamps
    end
  end
end
