class PasswordResetMailer < ApplicationMailer
  default from: "no-reply@zona44.com"

  def send_code(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: "🔐 Código de Recuperación - Zona 44")
  end
end
