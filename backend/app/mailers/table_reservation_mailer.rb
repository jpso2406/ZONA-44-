
class TableReservationMailer < ApplicationMailer
  def confirmation_email
    @reservation = params[:reservation]
    mail(
      to: @reservation.email,
      subject: "¡Tu reserva de mesa ha sido confirmada!"
    )
  end
end
