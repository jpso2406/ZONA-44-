class Producto < ApplicationRecord
  belongs_to :grupo
    has_one_attached :foto
end
