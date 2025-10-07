class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto
  has_many :productos

  validates :nombre, presence: true, uniqueness: { case_sensitive: false }

  before_save :generar_slug

 def foto_url
    if foto.attached?
      Rails.application.routes.url_helpers.rails_blob_url(
        foto,
        host: ENV["HOST_URL"] || "http://localhost:3000"
      )
    end
  end

  private

  def generar_slug
    self.slug = nombre.parameterize if nombre.present?
  end
end
