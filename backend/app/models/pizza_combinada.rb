class PizzaCombinada < ApplicationRecord
  self.table_name = "pizza_combinadas"
  has_one_attached :foto

  has_many :pizza_tamanos, dependent: :destroy
  has_many :tamanos, through: :pizza_tamanos, source: :tamano_pizza

  validates :nombre, presence: true, uniqueness: true
  validates :descripcion, presence: true
  validates :categoria, presence: true, inclusion: { in: [ "combinada" ] }

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

  # Método para obtener las pizzas tradicionales disponibles para combinación
  def self.pizzas_tradicionales_disponibles
    PizzaTradicional.activas
  end
end
