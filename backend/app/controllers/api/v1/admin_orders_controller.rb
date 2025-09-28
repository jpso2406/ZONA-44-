module Api
  module V1
    class AdminOrdersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_admin!

      # GET /api/v1/admin/orders
      def index
        orders = Order.includes(:user, :order_items => :producto).order(created_at: :desc).limit(50)
        render json: orders.as_json(
          include: {
            user: { only: [:id, :email, :first_name, :last_name] },
            order_items: {
              include: { producto: { only: [:id, :nombre, :precio] } },
              only: [:id, :quantity, :unit_price, :total_price]
            }
          },
          except: [:payu_response, :updated_at]
        )
      end

      # PATCH /api/v1/admin/orders/:id
      def update
        order = Order.find_by(id: params[:id])
        unless order
          render json: { success: false, error: "Pedido no encontrado" }, status: :not_found and return
        end
        if order.update(status: params[:status])
          render json: { success: true, order: order }
        else
          render json: { success: false, errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private
      def authenticate_admin!
        user = User.find_by(api_token: request.headers["Authorization"])
        unless user&.admin?
          render json: { success: false, message: "No autorizado" }, status: :unauthorized
        end
      end
    end
  end
end
