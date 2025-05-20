class Admin < ApplicationRecord
  # Elimina :registerable para evitar registros desde la vista
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Correo autorizado
  ALLOWED_ADMIN_EMAIL = "ojeison21@gmail.com" # <-- cámbialo por el tuyo

  # Solo permitir el login si el correo coincide
  def active_for_authentication?
    super && email == ALLOWED_ADMIN_EMAIL
  end

  # Mensaje personalizado si no está autorizado
  def inactive_message
    email != ALLOWED_ADMIN_EMAIL ? :not_authorized : super
  end
end
