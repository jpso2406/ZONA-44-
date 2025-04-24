class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellido
      t.integer :edad
      t.string :correo

      t.timestamps
    end
  end
end
