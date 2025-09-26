class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  enum :role, { user: 0, admin: 1 }   # ✅ sintaxis Rails 7.1+
  def password_required?
    new_record? ? false : super
  end

  has_many :orders
end
