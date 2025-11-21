class OrderInvoiceMailer < ApplicationMailer
  default from: "no-reply@zona44.com"

  def invoice(order)
    @order = order
    @user = order.user
    mail(to: @order.customer_email, subject: "📄 Detalles de la orden - Zona 44")
  end
end
