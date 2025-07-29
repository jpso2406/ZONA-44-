class ProductoAdicional < ApplicationRecord
  self.table_name = "producto_adicionales" # necesario si hubo problemas previos
  belongs_to :producto
  belongs_to :adicional
end