class CreateSubgrupos < ActiveRecord::Migration[8.0]
  def change
    create_table :subgrupos do |t|
      t.string :name
      t.integer :precio
      t.string :descripcion

      t.timestamps
    end
  end
end
