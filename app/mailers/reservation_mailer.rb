class ReservationMailer < ApplicationMailer
  def reservated_email(reservation)
    @reservation = reservation
    mail to: @reservation.email, subject: "#{@reservation.restaurant.name}'s reservation information."
  end
end
