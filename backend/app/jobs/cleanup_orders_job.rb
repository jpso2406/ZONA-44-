class CleanupOrdersJob < ApplicationJob
  queue_as :default

  def perform
    Order.cleanup_orphaned_orders
  end
end
