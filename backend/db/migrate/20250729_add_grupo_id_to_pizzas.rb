class AddGrupoIdToPizzas < ActiveRecord::Migration[8.0]
  def change
    add_column :pizza_tradicionales, :grupo_id, :bigint
    add_column :pizza_especiales, :grupo_id, :bigint
    add_index :pizza_tradicionales, :grupo_id
    add_index :pizza_especiales, :grupo_id
  end
end
