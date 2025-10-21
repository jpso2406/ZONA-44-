class CreateTableReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :table_reservations do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.date :date
      t.time :time
      t.integer :people_count
      t.string :status
      t.integer :user_id
      t.text :comments

      t.timestamps
    end
  end
end
