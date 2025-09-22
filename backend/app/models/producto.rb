# app/models/producto.rb
class Producto < ApplicationRecord
  belongs_to :grupo
  has_one_attached :foto

  has_many :producto_adicionales, class_name: "ProductoAdicional", dependent: :destroy
  has_many :adicionales, through: :producto_adicionales, source: :adicional

  has_many :producto_ingredientes, dependent: :destroy
  has_many :ingredientes, through: :producto_ingredientes

  def foto_url
    if foto.attached?
      Rails.application.routes.url_helpers.url_for(foto)
    else
      nil
    end
  end

  def adicional_ids
    adicionales.pluck(:id)
  end

  def adicional_ids=(ids)
    self.adicionales = Adicional.where(id: ids.reject(&:blank?))
  end
end

