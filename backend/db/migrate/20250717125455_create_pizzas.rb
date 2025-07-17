class CreatePizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :pizzas do |t|
      t.string :nombre
      t.text :descripcion
      t.string :categoria # 'tradicional' o 'especial'
      t.text :ingredientes
      t.boolean :borde_queso, default: false
      t.boolean :combinada, default: false
      t.references :grupo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
