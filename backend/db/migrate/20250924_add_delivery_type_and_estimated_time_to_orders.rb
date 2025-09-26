class AddDeliveryTypeAndEstimatedTimeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :delivery_type, :string, null: false, default: "domicilio"
    add_column :orders, :estimated_time, :integer
  end
end
