class DropPizzaTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :tamano_pizzas
    drop_table :pizzas
  end
end
