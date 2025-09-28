class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  enum :role, { user: 0, admin: 1 }   # ✅ sintaxis Rails 7.1+
  def password_required?
    new_record? ? false : super
  end

  has_many :orders

  def self.from_omniauth(auth)
    # Primero buscar por provider y uid (usuario OAuth existente)
    user = where(provider: auth.provider, uid: auth.uid).first
    
    if user
      return user
    end
    
    # Si no existe, buscar por email (usuario manual existente)
    existing_user = find_by(email: auth.info.email)
    
    if existing_user
      # Si existe un usuario con ese email pero sin OAuth, conectar OAuth
      existing_user.update!(
        provider: auth.provider,
        uid: auth.uid
      )
      return existing_user
    end
    
    # Si no existe ningún usuario, crear uno nuevo
    create!(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      first_name: auth.info.given_name || auth.info.first_name || auth.info.name&.split(' ')&.first,
      last_name: auth.info.family_name || auth.info.last_name || auth.info.name&.split(' ')&.last,
      provider: auth.provider,
      uid: auth.uid
    )
  end
end
