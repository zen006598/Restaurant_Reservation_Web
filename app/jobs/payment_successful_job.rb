class PaymentSuccessfulJob < ApplicationJob
  queue_as :default

  def perform(reservation, transaction_id, _maskedCreditCardNumber)
    ReservationMailer.payment_successful(reservation, transaction_id, credit_card_number).deliver
  end
end
