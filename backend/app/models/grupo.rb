class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto

  before_save :generar_slug

  def to_param
    slug
  end

  private

  def generar_slug
    self.slug = nombre.parameterize if slug.blank?
  end
end
