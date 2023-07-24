class AddArchivedToMatquotes < ActiveRecord::Migration[7.0]
  def change
    add_column :matquotes, :archived, :boolean
  end
end
