class ReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    ReservationMailer.reservated_email(reservation).deliver
  end
end
