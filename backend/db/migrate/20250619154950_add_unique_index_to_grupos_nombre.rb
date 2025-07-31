class AddUniqueIndexToGruposNombre < ActiveRecord::Migration[8.0]
  def change
    add_index :grupos, :nombre, unique: true
  end
end
