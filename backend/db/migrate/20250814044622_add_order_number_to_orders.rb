class AddOrderNumberToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :order_number, :string
  end
end
