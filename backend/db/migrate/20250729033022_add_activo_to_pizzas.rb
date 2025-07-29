class AddActivoToPizzas < ActiveRecord::Migration[8.0]
  def change
    add_column :pizza_tradicionales, :activo, :boolean, default: true
    add_column :pizza_especiales, :activo, :boolean, default: true
    add_column :pizza_combinadas, :activo, :boolean, default: true
  end
end 