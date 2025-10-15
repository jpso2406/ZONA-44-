class Promocion < ApplicationRecord
  self.table_name = "promociones"
  belongs_to :producto
  has_one_attached :imagen
end
