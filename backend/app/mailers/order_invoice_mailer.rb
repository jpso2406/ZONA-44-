class OrderInvoiceMailer < ApplicationMailer
  default from: "no-reply@zona44.com"

  def invoice(order)
    @order = order
    @user = order.user
    mail(to: @order.customer_email, subject: "📄 Factura Electrónica - Zona 44")
  end
end
