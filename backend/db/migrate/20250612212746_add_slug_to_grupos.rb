class AddSlugToGrupos < ActiveRecord::Migration[8.0]
  def change
    add_column :grupos, :slug, :string
    add_index :grupos, :slug, unique: true
  end
end
