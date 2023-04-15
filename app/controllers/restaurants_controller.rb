class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: %i[show get_business_times get_available_seat get_unavailable_time]

  def index
    @restaurants = Restaurant.all
  end

  def show
    # return flatpickr setting
    disable_dates = @restaurant.disable_dates
    @default_date = @restaurant.enable_dates.first
    max_date = Date.today + @restaurant.period_of_reservation.days
    @reservation = Reservation.new

    key = Seat.sha1(@restaurant.id)
    @maximum_capacity = $redis.hmget(key, :maximum_capacity).first.to_i

    respond_to do |format|
      format.json { render json: { maxDate: max_date, disable: disable_dates, defaultDate: @default_date} }
      format.html { render :show }
    end
  end

  def get_business_times
    day_of_week = params[:reservationDate].to_date.wday
    day = params[:reservationDate].in_time_zone
    table_type = Reservation.table_types[params[:tableType]]
    people_sum = params[:peopleSum]

    key = Reservation.unavaliable_time_sha1(params[:id], day, table_type)
    get_unavailable_times(key)

    avaliable_quantity = @restaurant.seats.table_type(table_type).more_than_capacity(people_sum).size
    reservations = @restaurant.reservations.except_canceled.which_table_type(table_type)
                              .search_arrival_date(day.strftime('%Y-%m-%d'))
                              .exculde_arrival_times(@unavailable_times)
                              .more_than_people_sum(people_sum)
                              .pluck(:arrival_time)
                              .tally

    unavailable_times = @unavailable_times.map(&:to_time)
    unavailable_times = reservations.select{|arrival_time, reservation_quantity| reservation_quantity >= avaliable_quantity}.keys.concat(unavailable_times).map(&:to_i)

    time_module = @restaurant.time_modules.in_which_time_module(day_of_week)

    business_times = time_module.available_reservable_time(day) - unavailable_times
    # business_times: [1680778800, 1680780600, 1680782400]
    render json:{businessTimes: business_times}
  end
  
  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def get_unavailable_times(key)
    @unavailable_times = $redis.smembers(key)
  end
end