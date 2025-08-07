class CreatePromocions < ActiveRecord::Migration[8.0]
  def change
    create_table :promociones do |t|
      t.timestamps
    end
  end
end
