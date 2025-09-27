module Api
  module V1
    class UserOrdersController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      # GET /api/v1/user_orders
      def index
        token = request.headers["Authorization"]
        user = User.find_by(api_token: token)
        unless user
          render json: { success: false, message: "No autorizado" }, status: :unauthorized and return
        end

        orders = user.orders.order(created_at: :desc).includes(:order_items)
        render json: orders.as_json(
          only: [ :id, :order_number, :status, :delivery_type, :total_amount, :created_at ],
          include: {
            order_items: {
              only: [ :id, :quantity, :unit_price, :total_price ],
              include: {
                producto: { only: [ :id, :name, :precio, :descripcion ] }
              }
            }
          }
        )
      end
    end
  end
end
