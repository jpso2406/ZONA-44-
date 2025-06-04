class Producto < ApplicationRecord
  has_one_attached :foto

  def clean_precio
  self.precios = precios.to_s.gsub(/[^\d]/, "").to_i if precios.present?
  end
end
