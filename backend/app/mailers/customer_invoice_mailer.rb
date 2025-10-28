class CustomerInvoiceMailer < ApplicationMailer
  default from: "no-reply@zona44.com"

  TEMPLATE_DOMICILIO = "invoice_domicilio".freeze
  TEMPLATE_RECOGER   = "invoice_recoger".freeze
  SUBJECT_DEFAULT    = "📄 Confirmación de Pedido - Zona 44".freeze

  def invoice(raw_order)
    log :debug, "Iniciando envío de factura", raw_order: raw_order

    @order = resolve_order(raw_order)
    return log(:warn, "Orden no encontrada o inválida", raw_order: raw_order) unless @order.present?

    log :info, "Generando invoice", order: @order

    mail(
      to: @order.customer_email,
      subject: SUBJECT_DEFAULT
    ) do |format|
      format.html { render template: "customer_invoice_mailer/#{select_template(@order.delivery_type)}" }
    end

  rescue => e
    log :error, "Error generando invoice: #{e.class} - #{e.message}", exception: e
  end

  private

  # === Resolución robusta del pedido ===
  def resolve_order(raw)
    return raw if raw.is_a?(Order)

    # Si viene como id numérico o string numérica
    if raw.to_s.match?(/\A\d+\z/)
      return Order.find_by(id: raw.to_i)
    end

    # Si es GlobalID (p. ej. "gid://...")
    GlobalID::Locator.locate(raw)
  rescue => e
    log :warn, "Error al resolver orden", raw_order: raw, exception: e
    nil
  end

  # === Selección del template según tipo de entrega ===
  def select_template(delivery_type)
    dt = delivery_type.to_s.strip.downcase

    case dt
    when "domicilio", "delivery", "envio"
      TEMPLATE_DOMICILIO
    when "recoger", "pickup"
      TEMPLATE_RECOGER
    else
      log :warn, "delivery_type desconocido, usando fallback domicilio", delivery_type: dt
      TEMPLATE_DOMICILIO
    end
  end

  # === Logging unificado ===
  def log(level, message, raw_order: nil, order: nil, delivery_type: nil, exception: nil)
    parts = ["[CustomerInvoiceMailer]", message]
    parts << "order_id=#{order&.id}" if order
    parts << "delivery_type=#{order&.delivery_type || delivery_type}" if order || delivery_type
    parts << "customer_email=#{order&.customer_email}" if order&.customer_email
    parts << "raw_order=#{raw_order.inspect}" if raw_order
    parts << "error=#{exception.message}" if exception

    Rails.logger.public_send(level, parts.join(" | "))
    nil
  end
end
