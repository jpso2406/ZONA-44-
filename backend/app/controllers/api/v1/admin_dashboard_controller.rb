module Api
  module V1
    class AdminDashboardController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :authenticate_admin!

      # GET /api/v1/admin/dashboard
      def index
        stats = {
          total_orders: Order.count,
          total_revenue: Order.where(status: "paid").sum(:total_amount),
          processing_orders: Order.where(status: "processing").count,
          paid_orders: Order.where(status: "paid").count,
          recent_orders: Order.includes(:order_items)
                                 .order(created_at: :desc)
                                 .limit(5)
                                 .as_json(
                                   only: [ :id, :order_number, :customer_name, :total_amount, :status, :created_at ]
                                 ),
          monthly_revenue: calculate_monthly_revenue,
          orders_by_status: [
            { status: "processing", count: Order.where(status: "processing").count },
            { status: "paid", count: Order.where(status: "paid").count }
          ]
        }

        render json: stats
      end

      private

      def authenticate_admin!
        user = User.find_by(api_token: request.headers["Authorization"])
        unless user&.admin?
          render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
      end

      def calculate_monthly_revenue
        # Últimos 6 meses
        (0..5).map do |months_ago|
          date = months_ago.months.ago
          month_name = date.strftime("%b")
          revenue = Order.where(
            status: "paid",
            created_at: date.beginning_of_month..date.end_of_month
          ).sum(:total_amount)
          { month: month_name, revenue: revenue }
        end.reverse
      end
    end
  end
end
