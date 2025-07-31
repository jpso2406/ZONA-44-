class CreateAdicionalTamanos < ActiveRecord::Migration[8.0]
  def change
    create_table :adicional_tamanos do |t|
      t.references :adicional, null: false, foreign_key: true
      t.references :tamano_pizza, null: false, foreign_key: true
      t.decimal :precio, precision: 8, scale: 2, null: false
      t.timestamps
    end
    add_index :adicional_tamanos, [ :adicional_id, :tamano_pizza_id ], unique: true
  end
end
