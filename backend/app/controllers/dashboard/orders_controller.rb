class Dashboard::OrdersController < Dashboard::DashboardController
  before_action :set_order, only: [ :show, :update, :confirm_cash_payment, :cancel_order ]

  def index
  @orders = Order.includes(:order_items)
           .order(created_at: :desc)

    @total_orders = Order.count
    @pending_orders = Order.pending.count
    @paid_orders = Order.paid.count
    @failed_orders = Order.failed.count
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def update
    if @order.update(order_params)
      redirect_to dashboard_order_path(@order), notice: "Orden actualizada exitosamente."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def confirm_cash_payment
    if @order.payment_method == "cash" && @order.pending?
      @order.update!(
        status: :paid,
        payu_response: @order.payu_response.present? ? @order.payu_response : {
          confirmed_at: Time.current.iso8601,
          confirmed_by: current_admin.email
        }.to_json
      )

      redirect_to dashboard_order_path(@order), notice: "Pago en efectivo confirmado exitosamente."
    else
      redirect_to dashboard_order_path(@order), alert: "No se puede confirmar este pago."
    end
  end

  def cancel_order
    if @order.pending? || @order.processing?
      @order.update!(
        status: :cancelled,
        payu_response: @order.payu_response.present? ? @order.payu_response : {
          cancelled_at: Time.current.iso8601,
          cancelled_by: current_admin.email
        }.to_json
      )

      redirect_to dashboard_order_path(@order), notice: "Orden cancelada exitosamente."
    else
      redirect_to dashboard_order_path(@order), alert: "No se puede cancelar esta orden."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :customer_name, :customer_email, :customer_phone)
  end
end
