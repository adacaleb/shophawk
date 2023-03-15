class AddTodoListToSlideshows < ActiveRecord::Migration[7.0]
  def change
    add_column :slideshows, :todoList, :string
  end
end
