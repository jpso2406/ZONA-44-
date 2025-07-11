class CreateIngredientes < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredientes do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
