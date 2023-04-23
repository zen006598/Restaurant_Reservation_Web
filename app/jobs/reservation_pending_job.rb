class ReservationPendingJob < ApplicationJob
  queue_as :default

  def perform(reservation)
    ReservationMailer.pending_email(reservation).deliver
  end
end
