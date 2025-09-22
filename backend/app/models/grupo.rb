class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto
  has_many :productos

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }

  before_save :generar_slug

  def foto_url
    foto.attached? ? Rails.application.routes.url_helpers.rails_blob_url(foto, only_path: false) : nil
  end

  private

  def generar_slug
    self.slug = nombre.parameterize if nombre.present?
  end
end
