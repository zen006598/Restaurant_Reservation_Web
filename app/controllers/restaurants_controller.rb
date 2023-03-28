class RestaurantsController < ApplicationController
  before_action :find_restaurant, only: %i[show]

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

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
