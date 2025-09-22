class Ingrediente < ApplicationRecord

  has_many :producto_ingredientes, dependent: :destroy
  has_many :productos, through: :producto_ingredientes

end
