module Api
  module V1
    class OrdersController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      # POST /api/v1/orders/track
      def track
        order = Order.find_by(
          order_number: params[:order_number],
          customer_email: params[:email]
        )

        if order
          render json: {
            success: true,
            order: order.as_json(
              include: [
                :user,
                order_items: { include: :producto }
              ],
              methods: [:customer_address, :customer_city]
            ),
            stats: {
              total_orders: Order.count,
              pending_orders: Order.where(status: "pending").count,
              processing_orders: Order.where(status: "processing").count,
              paid_orders: Order.where(status: "paid").count,
              total_revenue: Order.where(status: "paid").sum(:total_amount),
              orders_by_status: [
                { status: "pending", count: Order.where(status: "pending").count },
                { status: "processing", count: Order.where(status: "processing").count },
                { status: "paid", count: Order.where(status: "paid").count }
              ]
            }
          }
        else
          render json: { success: false, error: "Orden no encontrada" }, status: :not_found
        end
      end

      # POST /api/v1/orders
      def create
        customer = params[:customer] || {}
        cart = params[:cart] || []
        delivery_type = params[:delivery_type]
        allowed_types = %w[domicilio recoger]

        unless allowed_types.include?(delivery_type)
          return render json: {
            success: false,
            errors: ["delivery_type es requerido y debe ser 'domicilio' o 'recoger'"]
          }, status: :unprocessable_entity
        end

        generated_order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"

        order = Order.new(
          customer_name: customer[:name],
          customer_email: customer[:email],
          customer_phone: customer[:phone],
          customer_address: customer[:address],
          customer_city: customer[:city],
          total_amount: params[:total_amount] || 0,
          order_number: generated_order_number,
          reference: generated_order_number,
          delivery_type: delivery_type,
          user_id: params[:user_id],
          status: "pending" # ✅ Estado inicial pendiente
        )

        # Asociar productos del carrito
        cart.each do |item|
          producto = Producto.find_by(id: item[:producto_id])
          next unless producto

          quantity = item[:cantidad] || 1
          unit_price = producto.precio || 0

          order.order_items.build(
            producto: producto,
            quantity: quantity,
            unit_price: unit_price,
            total_price: unit_price * quantity
          )
        end

        if order.save
          render json: {
            success: true,
            order_id: order.id,
            status: order.status,
            message: "Orden creada exitosamente y en estado pendiente"
          }
        else
          render json: { success: false, errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/orders/:id/pay
      def pay
        order = Order.find_by(id: params[:id])
        unless order
          render json: { success: false, error: "Orden no encontrada" }, status: :not_found and return
        end

        # Si la orden falló anteriormente, generar un nuevo reference code para PayU
        if order.status == "failed"
          order.update(order_number: "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}")
        end

        card_data = {
          number: params[:card_number],
          expiration: params[:card_expiration],
          cvv: params[:card_cvv],
          name: params[:card_name]
        }

        payu = PayuService.new(order, card_data)
        response = payu.create_payment("VISA")

        if response["code"] == "SUCCESS" && response.dig("transactionResponse", "state") == "APPROVED"
          # ✅ El pago fue aprobado, pero la orden se mantiene en 'pending'
          order.update(
            payu_transaction_id: response.dig("transactionResponse", "transactionId"),
            payu_response: response.to_json
          )

          # Enviar correo de confirmación y factura electrónica
          OrderMailer.payment_success(order).deliver_later
          OrderInvoiceMailer.invoice(order).deliver_later

          render json: {
            success: true,
            message: "Pago aprobado. La orden sigue pendiente hasta que el administrador la procese.",
            order_id: order.id,
            status: order.status
          }
        else
          order.update(status: "failed", payu_response: response.to_json)
          render json: {
            success: false,
            error: response.dig("transactionResponse", "responseMessage") || "Pago rechazado"
          }
        end
      end
    end
  end
end
