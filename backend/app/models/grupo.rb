class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto
  has_many :productos

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }

  before_save :generar_slug

  private

  def generar_slug
    self.slug = nombre.parameterize if nombre.present?
  end
end
