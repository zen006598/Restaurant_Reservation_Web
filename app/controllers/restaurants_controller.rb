class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: %i[show get_business_times get_available_seat]

  def index
    @restaurants = Restaurant.all
  end

  def show
    enable_day = RestaurantsHelper::ReservationDate.new(@restaurant.period_of_reservation, @restaurant.off_day_of_week, @restaurant.off_days.after_today).business_days
    @reservation = Reservation.new

    respond_to do |format|
      format.json { render json: { enable_day: enable_day} }
      format.html { render :show }
    end
  end

  def get_business_times
    date = params[:day].to_date.wday
    day = params[:day]
    time_module = @restaurant.time_modules.included_date(date).first

    business_times = time_module.business_times.map do |business_time|
      ("#{day}-#{business_time.start.strftime('%R')}".to_time.to_i .. "#{day}-#{business_time._end.strftime('%R')}".to_time.to_i)
      .step(@restaurant.interval_time.minutes)
    end

    # return Selected dates and business hours to convert to numbers, format: [1680778800, 1680780600, 1680782400]
    render json:{business_times: business_times}
  end

  def get_available_seat
    people_sum = params[:people_sum]
    seats = @restaurant.seats.pluck(:capacity)
    maximum_capacity = seats.max
    render json:{alert: 'unavailable'} if people_sum > maximum_capacity
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
