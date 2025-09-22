class OrderMailer < ApplicationMailer
  default from: 'no-reply@zona44.com'

  def payment_success(order)
    @order = order
    mail(to: @order.customer_email, subject: '¡Pago exitoso en Zona 44!')
  end
end
