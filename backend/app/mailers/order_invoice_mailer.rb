class OrderInvoiceMailer < ApplicationMailer
  def invoice(order)
    @order = order
    @user = order.user
    mail(to: @order.customer_email, subject: 'Factura electrónica de tu pedido')
  end
end
