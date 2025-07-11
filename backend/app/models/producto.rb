# app/models/producto.rb
class Producto < ApplicationRecord
  belongs_to :grupo
  has_one_attached :foto

  has_many :producto_adicionales, class_name: "ProductoAdicional"
  has_many :adicionales, through: :producto_adicionales, source: :adicional

  def adicional_ids
    adicionales.pluck(:id)
  end

  def adicional_ids=(ids)
    self.adicionales = Adicional.where(id: ids.reject(&:blank?))
  end
end

