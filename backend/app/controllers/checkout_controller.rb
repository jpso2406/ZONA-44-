class CheckoutController < ApplicationController
  before_action :load_cart_items, only: [:new, :create]
  before_action :load_order, only: [:show, :payment_success, :payment_failed]
  
  def new
    @order = Order.new
    @total_amount = calculate_cart_total
  end
  
  def create
  @order = Order.new(order_params)
  @order.total_amount = calculate_cart_total
  # Asignar referencia simulada
  @order.reference = "REF-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
    
    if @order.save
      # Crear items del pedido desde el carrito
      create_order_items_from_cart(@order)
      
      # Redirigir al proceso de pago
  redirect_to payment_checkout_path(@order), notice: 'Pedido creado exitosamente. Procede con el pago.'
    else
      @total_amount = calculate_cart_total
      render :new, status: :unprocessable_entity
    end
  end
  
  def payment
    @order = Order.find(params[:id])
    @payment_methods = [
      { id: 'credit_card', name: 'Tarjeta de Crédito', icon: '💳' },
      { id: 'debit_card', name: 'Tarjeta de Débito', icon: '💳' },
      { id: 'pse', name: 'PSE (Pagos Seguros en Línea)', icon: '🏦' },
      { id: 'cash', name: 'Efectivo', icon: '💵' }
    ]
  end
  
  def process_payment
    @order = Order.find(params[:id])
    payment_method = params[:payment_method]
    
    # Inicializar servicio de PayU
    payu_service = PayuService.new(@order)
    
    # Simular el proceso de pago
    result = payu_service.simulate_payment(payment_method)
    
    if result[:success]
      case payment_method
      when 'cash'
        redirect_to payment_success_checkout_path(@order), notice: 'Pago en efectivo registrado. Se confirmará al recibir el dinero.'
      else
        redirect_to payment_success_checkout_path(@order), notice: 'Pago procesado exitosamente!'
      end
    else
      redirect_to checkout_payment_failed_path(@order), alert: "Error en el pago: #{result[:error]}"
    end
  end
  
  def payment_success
    # Limpiar el carrito después de un pago exitoso
    session[:carrito] = []
    # Enviar correo solo si no se ha enviado antes (usando un flag en la sesión)
    unless session[:payment_success_email_sent]
      OrderMailer.payment_success(@order).deliver_later if @order&.customer_email.present?
      session[:payment_success_email_sent] = true
    end
    flash[:success] = '¡Pedido confirmado y pagado exitosamente!'
  end
  
  def payment_failed
    # El pedido ya está marcado como fallido por el servicio
    flash[:alert] = 'El pago no pudo ser procesado. Intenta nuevamente o contacta soporte.'
  end
  
  def show
    # Mostrar detalles del pedido
  end
  
  private
  
  def order_params
    params.require(:order).permit(:customer_name, :customer_email, :customer_phone)
  end
  
  def load_cart_items
    @cart_items = session[:carrito] || []
    @cart_products = Producto.where(id: @cart_items).includes(foto_attachment: :blob)
    
    # Contar cantidades
    @cart_quantities = @cart_items.tally
  end
  
  def load_order
    @order = Order.find(params[:id])
  end
  
  def calculate_cart_total
    return 0 if @cart_items.empty?
    
    @cart_products.sum do |product|
      quantity = @cart_quantities[product.id.to_s] || 0
      (product.precio || 0) * quantity
    end
  end
  
  def create_order_items_from_cart(order)
    @cart_products.each do |producto|
      quantity = @cart_quantities[producto.id.to_s] || 0
      next if quantity <= 0
      
      order.order_items.create!(
        producto: producto,
        quantity: quantity,
        unit_price: producto.precio || 0,
        total_price: (producto.precio || 0) * quantity
      )
    end
    
    # Actualizar el total del pedido
    order.update_total
  end
end
