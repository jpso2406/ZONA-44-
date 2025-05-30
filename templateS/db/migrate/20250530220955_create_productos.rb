class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :name
      t.string :descripcion
      t.integer :precios

      t.timestamps
    end
  end
end
