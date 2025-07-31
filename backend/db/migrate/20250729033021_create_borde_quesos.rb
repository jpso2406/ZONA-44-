class CreateBordeQuesos < ActiveRecord::Migration[8.0]
  def change
    create_table :borde_quesos do |t|
      t.references :tamano_pizza, null: false, foreign_key: true
      t.decimal :precio, precision: 10, scale: 2

      t.timestamps
    end

    add_index :borde_quesos, :tamano_pizza_id, unique: true
  end
end 