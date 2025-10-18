class AddAddressFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :customer_address, :string
    add_column :orders, :customer_city, :string
  end
end
