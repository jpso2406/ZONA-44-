
class PizzaTradicional < ApplicationRecord
  self.table_name = "pizza_tradicionales"
  belongs_to :grupo
  has_one_attached :foto
  

  has_many :pizza_tamanos, dependent: :destroy
  has_many :tamanos, through: :pizza_tamanos, source: :tamano_pizza

  validates :nombre, presence: true, uniqueness: true
  validates :descripcion, presence: true
  validates :categoria, presence: true, inclusion: { in: [ "tradicional" ] }

  scope :activas, -> { where(activo: true) }

  def precio_por_tamano(tamano)
    pizza_tamanos.joins(:tamano_pizza).find_by(tamano_pizzas: { nombre: tamano })&.precio
  end

  def disponible_en_tamano?(tamano)
    pizza_tamanos.joins(:tamano_pizza).exists?(tamano_pizzas: { nombre: tamano })
  end

  def tamanos_disponibles
    tamanos.order(:slices)
  end

  def precio_minimo
    pizza_tamanos.minimum(:precio) || 0
  end
end
