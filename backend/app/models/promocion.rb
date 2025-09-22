class Promocion < ApplicationRecord
  self.table_name = "promociones"
  has_one_attached :imagen
end
