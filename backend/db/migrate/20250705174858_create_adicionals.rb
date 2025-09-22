class CreateAdicionals < ActiveRecord::Migration[8.0]
  def change
    create_table :adicionals do |t|
      t.string :ingredientes

      t.timestamps
    end
  end
end
