class SmsTwsms2Job < ApplicationJob
  queue_as :default

  def perform(reservation)
    sms_client = Twsms2::Client.new(username: ENV['TWSMS2_ACOUNT'], password: ENV['TWSMS2_PASSWORD'])
    if sms_client.account_is_available
      sms_client.send_message to: reservation.phone,
                              content: "
                              Hello, #{reservation.name},
                              The following is your reservation information:
                                Restaurant: #{reservation.restaurant.name}
                                Dining time : #{reservation.arrival_time.strftime('%Y-%m-%d %H:%M')}
                                Type of table : #{reservation.table_type }
                                Party size : #{reservation.adult_quantity} Adult(s) #{reservation.child_quantity} Kid(s)"
    end
  end
end