class CreateGrupos < ActiveRecord::Migration[8.0]
  def change
    create_table :grupos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
