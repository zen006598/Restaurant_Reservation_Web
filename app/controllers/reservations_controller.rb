class ReservationsController < ApplicationController
  before_action :find_restaurant, only: %i[new create]
  before_action :find_reservation_info, only: %i[new]
  before_action :find_reservation, only: %i[show reservate cancel complete line_pay]
  skip_before_action :verify_authenticity_token, only: [:line_pay]
  
  def show
    @restaurant = @reservation.restaurant
  end

  def new
    @reservation = Reservation.new
  end
  
  def create
    @reservation = @restaurant.reservations.new(reservation_params)
    restaurant_key = @restaurant.sha1_key
    determine_cookie(restaurant_key, @reservation, @restaurant)

    if @reservation.save
      set_cookies(restaurant_key, @value)
      if @reservation.people_sum < @restaurant.headcount_requirement
        @reservation.reservate!
        ReservationJob.perform_later(@reservation) if @reservation.email.present?
      else
        ReservationPendingJob.perform_later(@reservation) if @reservation.email.present?
      end
      SmsTwsms2Job.perform_later(@reservation)
      return redirect_to @reservation
    else
      render :new
    end
  end

  def line_pay
    response = Payments::LinePay::AuthenticationApi.new(@reservation.id, @reservation.capitation, 
@reservation.people_sum).perform
    redirect_to response, allow_other_host: true
  end

  def confirm_url
    # request the confirm api
    reservation = Reservation.find(params['orderId'])
    response = Payments::LinePay::ConfirmApi.new(params['transactionId'], reservation.amount).perform
    response = JSON.parse(response)

    transaction_id = response['info']['transactionId']
    credit_card_number = response['info']['payInfo'].first['maskedCreditCardNumber']

    # After payment the reservation be reservated and send the email
    reservation.reservate! if reservation.may_reservate?
    PaymentSuccessfulJob.perform_later(reservation, transaction_id, 
credit_card_number) if reservation.email.present?
    redirect_to reservation_path(reservation), notice: 'payment successful!'
  end

  def cancel
    if @reservation.may_cancel?
      @reservation.cancel!
      # reset cookies
      restaurant_cookies = @reservation.restaurant.sha1_key
      value = cookies[restaurant_cookies].split('&').map(&:to_time).reject do |time|
        time == @reservation.arrival_time
      end
      set_cookies(restaurant_key, value)

      respond_to {|format| format.turbo_stream {
        render turbo_stream: turbo_stream.replace(@reservation, 
                                                  partial: "reservations/cancel", 
                                                  locals: {reservation: @reservation,
                                                          restaurant: @reservation.restaurant})}}
    end
  end

  def complete
    @reservation.complete! if @reser.may_complete?
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def reservation_params
    params.require(:reservation).permit(:name, :phone, :email, :gender, :comment, :arrival_time, 
                                        :adult_quantity, :child_quantity, :table_type)
  end

  def find_reservation_info
    @arrival_time = params[:arrival_time] 
    @child_quantity = params[:reservation][:child_quantity]
    @adult_quantity = params[:reservation][:adult_quantity]
    @table_type = params[:reservation][:table_type]
  end

  def find_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_cookies(key, value, expire = 3.days.from_now)
    cookies[key] = {value: value, expires: expire}
  end

  def determine_cookie(restaurant_key, reservation, restaurant)
    if cookies[restaurant_key]&.split('&')&.map(&:to_time)&.include?(reservation.arrival_time.to_time)
      return redirect_to repeat_booking_restaurant_reservations_path(restaurant)
    end

    if cookies[restaurant_key].nil?
      @value = "#{reservation.arrival_time}"
    else
      @value = ([cookies[restaurant_key].split('&')] << "#{reservation.arrival_time.to_s}").flatten
    end
  end
end
