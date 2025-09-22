class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :productos, through: :order_items
  
  # Validaciones
  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_phone, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  
  # Enums para el estado del pedido
  enum :status, {
    pending: 'pending',           # Pendiente de pago
    processing: 'processing',     # Procesando pago
    paid: 'paid',                # Pagado
    failed: 'failed',            # Pago fallido
    cancelled: 'cancelled'       # Cancelado
  }
  
  # Enums para método de pago
  enum :payment_method, {
    credit_card: 'credit_card',
    debit_card: 'debit_card',
    pse: 'pse',                  # PSE (Pagos Seguros en Línea)
    cash: 'cash'
  }
  
  # Callbacks
  before_create :generate_order_number
  after_create :create_order_items_from_cart
  
  # Métodos de instancia
  def add_product(producto, quantity = 1)
    order_items.create!(
      producto: producto,
      quantity: quantity,
      unit_price: producto.precio || 0,
      total_price: (producto.precio || 0) * quantity
    )
  end
  
  def update_total
    update(total_amount: order_items.sum(:total_price))
  end
  
  def can_be_paid?
    pending? && total_amount > 0
  end
  
  def mark_as_paid!(payu_transaction_id, payu_response)
    update!(
      status: :paid,
      payu_transaction_id: payu_transaction_id,
      payu_response: payu_response
    )
  end
  
  def mark_as_failed!(payu_response)
    update!(
      status: :failed,
      payu_response: payu_response
    )
  end
  
  private
  
  def generate_order_number
    loop do
      self.order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      break unless Order.exists?(order_number: order_number)
    end
  end
  
  def create_order_items_from_cart
    # Este método se implementará cuando integremos con el carrito
    # Por ahora está vacío
  end
end
