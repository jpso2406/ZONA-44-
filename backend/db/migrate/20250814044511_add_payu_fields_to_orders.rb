class AddPayuFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :payu_transaction_id, :string
    add_column :orders, :payu_response, :text
  end
end
