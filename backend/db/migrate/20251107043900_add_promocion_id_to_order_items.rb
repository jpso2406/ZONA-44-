class AddPromocionIdToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :promocion_id, :integer
  end
end
