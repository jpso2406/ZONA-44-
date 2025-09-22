class BordeQueso < ApplicationRecord
  belongs_to :tamano_pizza
  
  validates :tamano_pizza, presence: true, uniqueness: true
  validates :precio, presence: true, numericality: { greater_than: 0 }
  
  def nombre_tamano
    tamano_pizza.nombre
  end
  
  def tamano_cm
    tamano_pizza.tamano_cm
  end
end 