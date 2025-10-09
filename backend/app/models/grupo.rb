class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto
  has_many :productos

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }

  before_save :generar_slug

  def foto_url
    return nil unless foto.attached?
    if foto.variable?
      foto.variant(resize_to_limit: [ 400, 400 ], saver: { quality: 70 }).processed.url
    else
      foto.url
    end
  end

  private

  def generar_slug
    self.slug = nombre.parameterize if nombre.present?
  end
end
