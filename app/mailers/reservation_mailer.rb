class ReservationMailer < ApplicationMailer
  def reservated_email(reservation)
    @reservation = reservation
    mail to: @reservation.email, subject: "#{@reservation.restaurant.name}'s reservation information."
  end

  def pending_email(reservation)
    @reservation = reservation
    mail to: @reservation.email, subject: "#{@reservation.restaurant.name}'s reservation information."
  end

  def payment_successful(reservation, transaction_id, credit_card_number)
    @reservation = reservation
    @transaction_id = transaction_id
    @credit_card_number = credit_card_number
    mail to: @reservation.email, subject: "#{@reservation.restaurant.name}'s reservation information."
  end
end
