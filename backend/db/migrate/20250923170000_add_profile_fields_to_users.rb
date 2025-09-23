class AddProfileFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :document_type, :string
    add_column :users, :document_number, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :phone, :string
    add_column :users, :department, :string
    add_column :users, :city, :string
  end
end
