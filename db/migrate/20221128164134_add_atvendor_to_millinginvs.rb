class AddAtvendorToMillinginvs < ActiveRecord::Migration[7.0]
  def change
    add_column :millinginvs, :atvendor, :integer
  end
end
