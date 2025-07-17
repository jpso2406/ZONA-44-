class CreateTamanoPizzas < ActiveRecord::Migration[8.0]
  def change
    create_table :tamano_pizzas do |t|
      t.references :pizza, null: false, foreign_key: true
      t.string :tamano # personal, small, medium, large
      t.decimal :precio, precision: 10, scale: 2
      t.integer :tamano_cm # 20cm, 30cm, 40cm, 50cm

      t.timestamps
      
      t.index [:pizza_id, :tamano], unique: true
    end
  end
end
