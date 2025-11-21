class CreateAnuncios < ActiveRecord::Migration[8.0]
  def change
    create_table :anuncios do |t|
      t.boolean :activo, default: true, null: false
      t.integer :posicion, default: 0
      t.date :fecha_inicio
      t.date :fecha_fin

      t.timestamps
    end
    
    add_index :anuncios, :activo
    add_index :anuncios, :posicion
  end
end
