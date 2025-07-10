class ProductoAdicional < ApplicationRecord
  belongs_to :producto
  belongs_to :adicional
end
