# app/models/adicional.rb
class Adicional < ApplicationRecord
  has_many :producto_adicionales, class_name: "ProductoAdicional"
  has_many :productos, through: :producto_adicionales, source: :producto
  has_many :adicional_tamanos, dependent: :destroy
  has_many :tamano_pizzas, through: :adicional_tamanos

  def precio_por_tamano(tamano_pizza)
    adicional_tamanos.find_by(tamano_pizza: tamano_pizza)&.precio
  end
end
