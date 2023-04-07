class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: %i[show get_business_times get_available_seat get_unavailable_time]

  def index
    @restaurants = Restaurant.all
  end

  def show
    # return flatpickr setting
    reservation_dates = ReservationDate.new(@restaurant.off_days.after_today, @restaurant.time_modules, 
                                            @restaurant.period_of_reservation)
    disable_dates = reservation_dates.disable_dates
    default_day = reservation_dates.first_day
    max_date = Date.today + @restaurant.period_of_reservation.days

    @reservation = Reservation.new
    @alert = @restaurant.maximum_capacity.zero?

    unavailable_time(default_day, 'regular_table')

    respond_to do |format|
      format.json { render json: { maxDate: max_date, disable: disable_dates, defaultDate: default_day, fullyOccupiedTime: @fully_occupied_time} }
      format.html { render :show }
    end
  end

  def get_business_times
    day_of_week = params[:day].to_date.wday
    day = params[:day].in_time_zone
    
    time_module = @restaurant.time_modules.in_which_time_module(day_of_week)
    interval_time = @restaurant.interval_time
    business_times = BusinessTimeCounting.new(time_module, interval_time, day).reservable_time

    # return Selected dates and business hours to convert to numbers, 
    # format: [1680778800, 1680780600, 1680782400]
    render json:{business_times: business_times}
  end

  def get_available_seat
    people_sum = params[:people_sum]
    
    #return when the people over the maximum capacity.
    if people_sum <= @restaurant.maximum_capacity
      render json:{notice: true}
    else
      render json:{notice: false}
    end
  end

  def get_unavailable_time
    choice_date = params[:choiceDate]
    table_type = params[:tableType]
    unavailable_time(choice_date, table_type)

    # return the user choice day,and fully occupied time, format: [1680872400, 1680872500, 1680872600]
    render json: {fully_occupied_time: @fully_occupied_time }
  end

  def unavailable_time(choice_date, table_type)
    choice_date = choice_date.strftime('%Y-%m-%d') if choice_date.is_a?(Date)

    table_type_sum = @restaurant.seats.table_type_sum(table_type)
    reservations = @restaurant.reservations.on_or_after_now.pluck(:table_type, :arrival_time).tally
    
    reservations_keys = reservations.keys.select do |reservation| 
      reservation.include?(table_type) && reservation.last.strftime('%Y-%m-%d') == choice_date
    end

    reservations = reservations_keys.select do |reservation_key|
      reservations[reservation_key] >= table_type_sum
    end

    @fully_occupied_time  = reservations.map{|reservation| reservation.flatten.last.to_i}
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
