class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :name
      t.integer :precio
      t.string :descripcion

      t.timestamps
    end
  end
end
