module Api
  module V1
    class AdminDashboardController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :authenticate_admin!

      # GET /api/v1/admin/dashboard
      def index
        # Estadísticas generales
        total_orders = Order.count
        total_revenue = Order.where(status: ["paid", "processing"]).sum(:total_amount)
        pending_orders = Order.where(status: "pending").count
        processing_orders = Order.where(status: "processing").count
        paid_orders = Order.where(status: "paid").count

        # Pedidos recientes
        recent_orders = Order.includes(:user)
                             .order(created_at: :desc)
                             .limit(10)
                             .map do |order|
          {
            id: order.id,
            order_number: order.order_number,
            customer_name: order.customer_name,
            total_amount: order.total_amount,
            status: order.status,
            created_at: order.created_at
          }
        end

        # Ingresos mensuales (últimos 6 meses)
        monthly_revenue = Order.where("created_at >= ?", 6.months.ago)
                               .where(status: ["paid", "processing"])
                               .group(Arel.sql("DATE_TRUNC('month', created_at)"))
                               .order(Arel.sql("DATE_TRUNC('month', created_at) ASC"))
                               .sum(:total_amount)
                               .map do |date, revenue|
          {
            month: date.strftime("%b"),
            revenue: revenue
          }
        end

        # Pedidos por estado
        orders_by_status = [
          { status: "pending", count: pending_orders },
          { status: "processing", count: processing_orders },
          { status: "paid", count: paid_orders }
        ]

        render json: {
          total_orders: total_orders,
          total_revenue: total_revenue,
          pending_orders: pending_orders,
          processing_orders: processing_orders,
          paid_orders: paid_orders,
          recent_orders: recent_orders,
          monthly_revenue: monthly_revenue,
          orders_by_status: orders_by_status
        }
      end

      private

      def authenticate_admin!
        # Implementar lógica de autenticación de admin
        # Por ahora permitimos acceso para desarrollo
        true
      end
    end
  end
end