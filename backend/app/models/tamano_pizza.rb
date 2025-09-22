class TamanoPizza < ApplicationRecord
  has_many :pizza_tamanos, dependent: :destroy
  has_many :pizza_tradicionales, through: :pizza_tamanos
  has_many :pizza_especiales, through: :pizza_tamanos
  has_many :pizza_combinadas, through: :pizza_tamanos
  has_one :borde_queso, dependent: :destroy

  validates :nombre, presence: true, uniqueness: true
  validates :slices, presence: true, numericality: { greater_than: 0 }
  validates :tamano_cm, presence: true, numericality: { greater_than: 0 }

  scope :ordenados, -> { order(:slices) }

  def precio_borde_queso
    borde_queso&.precio || 0
  end

  def tiene_borde_queso?
    borde_queso.present?
  end
end
