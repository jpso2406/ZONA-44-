
class TableReservationMailer < ApplicationMailer
  default from: "no-reply@zona44.com"

  def confirmation_email
    @reservation = params[:reservation]
    mail(
      to: @reservation.email,
      subject: "✓ Reserva Confirmada - Zona 44 GastroBar"
    )
  end
end
