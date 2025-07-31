class CreateProductoIngredientes < ActiveRecord::Migration[8.0]
  def change
    create_table :producto_ingredientes do |t|
      t.references :producto, null: false, foreign_key: true
      t.references :ingrediente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
