class CreatePizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :pizzas do |t|
      t.string :nombre
      t.string :descripcion
      t.decimal :precio
      t.integer :tamano
      t.boolean :borde_queso
      t.integer :tipo_pizza
      t.references :adicional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
