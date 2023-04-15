class ReservationsController < ApplicationController
  before_action :find_restaurant, only: %i[new create]
  before_action :find_reservation_info, only: %i[new]
  before_action :find_reservation, only: %i[show edit update reservate cancel complete]
  
  def show
    @restaurant = @reservation.restaurant
  end

  def update
  end

  def edit
  end

  def new
    restaurant_key()
    unless cookies[@restaurant_key].nil?
      if cookies[@restaurant_key].split('&').map(&:to_time).include?(@arrival_time.to_time)
        redirect_to restaurant_path(@restaurant)
      end
    end
    @reservation = Reservation.new
  end
  
  def create
    @reservation = @restaurant.reservations.new(reservation_params)
    if @reservation.save
      set_duplicate_reservation_cookies()
      ReservationJob.perform_later(@reservation) if @reservation.email.present?
      redirect_to @reservation
    else
      render :new
    end
  end

  def reservate
    @reservation.reservate! if @reservation.may_reservate?
  end

  def cancel
    if @reservation.may_cancel?
      @reservation.cancel! 
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@reservation, 
                                                    partial: "reservations/cancel", 
                                                    locals: {reservation: @reservation, 
                                                            restaurant: @reservation.restaurant})
        }
      end
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

  def set_duplicate_reservation_cookies
    restaurant_key()
    if cookies[@restaurant_key].nil?
      cookies[@restaurant_key] = {value: "#{@reservation.arrival_time}", expires: 3.days.from_now}
    else
      value = ([cookies[@restaurant_key].split('&').flatten] << "#{@reservation.arrival_time.to_s}").flatten
      cookies[@restaurant_key]  = {value: value, expires: 3.days.from_now}
    end
  end

  def restaurant_key
    @restaurant_key = Digest::SHA1.hexdigest("#{@restaurant.id.to_s}")
  end
end
