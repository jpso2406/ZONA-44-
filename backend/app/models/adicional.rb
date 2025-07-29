# app/models/adicional.rb
class Adicional < ApplicationRecord
  has_many :producto_adicionales, class_name: "ProductoAdicional"
  has_many :productos, through: :producto_adicionales, source: :producto
end
