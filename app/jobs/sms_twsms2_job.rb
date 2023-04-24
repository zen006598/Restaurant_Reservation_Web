class SmsTwsms2Job < ApplicationJob
  queue_as :default

  def perform(reservation)
    if reservation.reservation?
      Sms::TwSms.new(reservation).perform_reservated
    elsif reservation.pending?
      Sms::TwSms.new(reservation).perform_reservated
    end
  end
end