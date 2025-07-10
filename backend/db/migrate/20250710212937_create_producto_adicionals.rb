class CreateProductoAdicionals < ActiveRecord::Migration[8.0]
  def change
    create_table :producto_adicionals do |t|
      t.references :producto, null: false, foreign_key: true
      t.references :adicional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
