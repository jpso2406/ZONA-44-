module Api
  module V1
    class OrdersController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      # POST /api/v1/orders
      def create
        # Espera params[:cart] (array de productos), params[:customer] (hash) y params[:delivery_type] (string)
        customer = params[:customer] || {}
        cart = params[:cart] || []
        delivery_type = params[:delivery_type]
        allowed_types = %w[domicilio recoger]
        unless allowed_types.include?(delivery_type)
          return render json: { success: false, errors: [ "delivery_type es requerido y debe ser 'domicilio' o 'recoger'" ] }, status: :unprocessable_entity
        end
        # Generar un order_number y usarlo como reference
        generated_order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
        order = Order.new(
          customer_name: customer[:name],
          customer_email: customer[:email],
          customer_phone: customer[:phone],
          total_amount: params[:total_amount] || 0,
          order_number: generated_order_number,
          reference: generated_order_number,
          delivery_type: delivery_type,
          user_id: params[:user_id],
          status: "pending"
        )
        # Asociar productos del carrito a la orden
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
          render json: { success: true, order_id: order.id, message: "Orden creada exitosamente" }
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

        card_data = {
          number: params[:card_number],
          expiration: params[:card_expiration],
          cvv: params[:card_cvv],
          name: params[:card_name]
        }
        payu = PayuService.new(order, card_data)
        response = payu.create_payment("VISA")

        if response["code"] == "SUCCESS" && response.dig("transactionResponse", "state") == "APPROVED"
          order.update(status: "processing", payu_transaction_id: response.dig("transactionResponse", "transactionId"), payu_response: response.to_json)
          # Enviar correo de confirmación y factura electrónica
          OrderMailer.payment_success(order).deliver_later
          OrderInvoiceMailer.invoice(order).deliver_later
          render json: { success: true, message: "Pago aprobado", order_id: order.id }
        else
          order.update(status: "failed", payu_response: response.to_json)
          render json: { success: false, error: response.dig("transactionResponse", "responseMessage") || "Pago rechazado" }
        end
      end
    end
  end
end
