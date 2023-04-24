module Sms
  class TwSms
    def initialize(reservation)
      @reservation = reservation
    end

    def perform_reservated
      sms_client
      reservated_content
      if @sms_client.account_is_available
        @sms_client.send_message to: @reservation.phone,
                                content: @content
      end
    end

    def perform_reservated
      sms_client
      pending_content
      if @sms_client.account_is_available
        @sms_client.send_message to: @reservation.phone,
                                content: @content
      end
    end

    private

    def sms_client
      @sms_client = Twsms2::Client.new(username: ENV['TWSMS2_ACOUNT'], password: ENV['TWSMS2_PASSWORD'])
    end

    def reservated_content
      @content = "Hello, #{@reservation.name},
      The following is your reservation information:
      Restaurant:#{@reservation.restaurant.name}
      Dining time:#{@reservation.arrival_time.strftime('%Y-%m-%d %H:%M')}
      Type of table:#{@reservation.table_type }
      Party size:#{@reservation.adult_quantity} Adult(s) #{@reservation.child_quantity} Kid(s)"
    end

    def pending_content
      @content = "Hello, #{@reservation.name},
      The following is your reservation information:
      Desposit: #{@reservation.amount}
      Restaurant:#{@reservation.restaurant.name}
      Dining time:#{@reservation.arrival_time.strftime('%Y-%m-%d %H:%M')}
      Type of table:#{@reservation.table_type }
      Party size:#{@reservation.adult_quantity} Adult(s) #{@reservation.child_quantity} Kid(s)
      payment link:#{line_pay_reservation_url(@reservation)}"
    end
  end
end