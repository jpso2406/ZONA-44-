class AdicionalTamano < ApplicationRecord
  belongs_to :adicional
  belongs_to :tamano_pizza

  validates :precio, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
