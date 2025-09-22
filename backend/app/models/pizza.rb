class Pizza < ApplicationRecord
  belongs_to :adicional

  has_one_attached :imagen

  enum :tamano, {
    small: 0,
    medium: 1,
    large: 2,
    family: 3,
  }
  
  enum :tipo_pizza, {
    tradicional: 0,
    especial: 1,
    combinada: 2,
  }

end
