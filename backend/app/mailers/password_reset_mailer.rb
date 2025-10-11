class PasswordResetMailer < ApplicationMailer
  def send_code(user, code)
    @user = user
    @code = code
    mail(to: @user.email, subject: 'Código de recuperación de contraseña')
  end
end
