class AddStatusToRunlists < ActiveRecord::Migration[7.0]
  def change
    add_column :runlists, :status, :string
  end
end
