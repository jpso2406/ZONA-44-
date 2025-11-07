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
              methods: [ :customer_address, :customer_city ]
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
            errors: [ "delivery_type es requerido y debe ser 'domicilio' o 'recoger'" ]
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
          promocion_id = item[:promocion_id]

          # ✅ Si es una promoción, usar precio de promoción
          if promocion_id.present?
            promocion = Promocion.find_by(id: promocion_id)
            unit_price = promocion&.precio_total || producto.precio || 0
          else
            unit_price = producto.precio || 0
          end

          order.order_items.build(
            producto: producto,
            promocion_id: promocion_id,
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

        # Verificar que la orden esté en estado pagable
        unless [ "pending", "failed" ].include?(order.status)
          return render json: {
            success: false,
            message: "Esta orden no se puede pagar en su estado actual"
          }, status: :unprocessable_entity
        end

        # 🔥 IMPORTANTE: Regenerar reference_code para reintentos (evita duplicados en PayU)
        new_reference = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
        order.update!(order_number: new_reference, reference: new_reference)

        card_data = {
          number: params[:card_number],
          expiration: params[:card_expiration],
          cvv: params[:card_cvv],
          name: params[:card_name]
        }

        payu = PayuService.new(order, card_data)
        response = payu.create_payment("VISA")

        if response["code"] == "SUCCESS" && response.dig("transactionResponse", "state") == "APPROVED"
          # ✅ El pago fue aprobado, cambiar estado a 'processing'
          order.update(
            status: "processing",
            payu_transaction_id: response.dig("transactionResponse", "transactionId"),
            payu_response: response.to_json
          )

          # Enviar correo de confirmación y factura electrónica
          OrderMailer.payment_success(order).deliver_later
          OrderInvoiceMailer.invoice(order).deliver_later

          render json: {
            success: true,
            message: "Pago aprobado. Tu orden está siendo procesada.",
            order_id: order.id,
            order_number: order.order_number,
            status: order.status
          }
        else
          order.update(status: "failed", payu_response: response.to_json)
          render json: {
            success: false,
            error: response.dig("transactionResponse", "responseMessage") || "Pago rechazado",
            error_details: response.dig("transactionResponse", "responseCode")
          }, status: :unprocessable_entity
        end
      rescue => e
        Rails.logger.error "Error en OrdersController#pay: #{e.message}"
        render json: {
          success: false,
          message: "Error interno al procesar el pago",
          error: e.message
        }, status: :internal_server_error
      end
    end
  end
end
