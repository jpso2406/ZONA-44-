class CreateTamanoPizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :tamano_pizzas do |t|
      t.string :nombre
      t.integer :slices
      t.integer :tamano_cm

      t.timestamps
    end
  end
end 