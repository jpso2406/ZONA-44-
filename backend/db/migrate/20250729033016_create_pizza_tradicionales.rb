class CreatePizzaTradicionales < ActiveRecord::Migration[8.0]
  def change
    create_table :pizza_tradicionales do |t|
      t.string :nombre
      t.text :descripcion
      t.string :categoria

      t.timestamps
    end
  end
end
