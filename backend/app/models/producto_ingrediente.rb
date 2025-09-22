class ProductoIngrediente < ApplicationRecord
  belongs_to :producto
  belongs_to :ingrediente
end
