class Admin < ApplicationRecord
  # Elimina :registerable para evitar registros desde la vista
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Correo autorizado
  ALLOWED_ADMIN_EMAILS = ["", ""]

  # Solo permitir el login si el correo coincide
  def active_for_authentication?
    super && ALLOWED_ADMIN_EMAILS.include?(email)
  end
  # Mensaje personalizado si no está autorizado
  def inactive_message
    email != ALLOWED_ADMIN_EMAIL ? :not_authorized : super
  end
end
