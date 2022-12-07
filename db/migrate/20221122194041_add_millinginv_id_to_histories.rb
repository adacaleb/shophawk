class AddMillinginvIdToHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :histories, :millinginv_id, :integer
  end
end
