class AddGrupoIdToProductos < ActiveRecord::Migration[8.0]
  def change
    add_reference :productos, :grupo, null: false, foreign_key: true
  end
end
