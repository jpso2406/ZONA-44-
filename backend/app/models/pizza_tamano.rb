class PizzaTamano < ApplicationRecord
  self.table_name = "pizza_tamanos"
  belongs_to :pizza_tradicional, optional: true
  belongs_to :pizza_especial, optional: true
  belongs_to :pizza_combinada, optional: true
  belongs_to :tamano_pizza

  validates :tamano_pizza, presence: true
  validates :precio, presence: true, numericality: { greater_than: 0 }

  # Validar que solo una pizza esté asociada
  validate :solo_una_pizza_asociada

  private

  def solo_una_pizza_asociada
    pizzas_asociadas = [ pizza_tradicional_id, pizza_especial_id, pizza_combinada_id ].compact
    if pizzas_asociadas.count != 1
      errors.add(:base, "Debe estar asociado a exactamente una pizza")
    end
  end
end
