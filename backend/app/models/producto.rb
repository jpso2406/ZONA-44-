# app/models/producto.rb
class Producto < ApplicationRecord
  belongs_to :grupo
  has_one_attached :foto

  has_many :producto_adicionales, class_name: "ProductoAdicional"
  has_many :adicionales, through: :producto_adicionales, source: :adicional
end

