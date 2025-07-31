class CreatePizzaTamanos < ActiveRecord::Migration[8.0]
  def change
    create_table :pizza_tamanos do |t|
      t.references :pizza_tradicional, null: true, foreign_key: { to_table: :pizza_tradicionales }
      t.references :pizza_especial, null: true, foreign_key: { to_table: :pizza_especiales }
      t.references :pizza_combinada, null: true, foreign_key: { to_table: :pizza_combinadas }
      t.references :tamano_pizza, null: false, foreign_key: { to_table: :tamano_pizzas }
      t.decimal :precio, precision: 10, scale: 2

      t.timestamps
    end

    add_index :pizza_tamanos, [:pizza_tradicional_id, :tamano_pizza_id], unique: true, name: 'index_pizza_tamanos_tradicional', where: 'pizza_tradicional_id IS NOT NULL'
    add_index :pizza_tamanos, [:pizza_especial_id, :tamano_pizza_id], unique: true, name: 'index_pizza_tamanos_especial', where: 'pizza_especial_id IS NOT NULL'
    add_index :pizza_tamanos, [:pizza_combinada_id, :tamano_pizza_id], unique: true, name: 'index_pizza_tamanos_combinada', where: 'pizza_combinada_id IS NOT NULL'
  end
end 