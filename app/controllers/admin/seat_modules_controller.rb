class Admin::SeatModulesController < ApplicationController
  layout 'application_backstage', only: %i[index]
  before_action :find_restaurant, only: %i[index create]

  def index
    @seat_modules = @restaurant.seat_modules
    @seat_module = SeatModule.new
  end

  def create 
    @seat_module = @restaurant.seat_modules.new(seat_modules_params)
    if @seat_module.save
      redirect_to admin_restaurant_seat_modules_path(@seat_module)
    else
      render :index, alert: 'error'
    end
  end

  def edit
  end

  private
  
  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def seat_modules_params
    params.require(:seat_module).permit(:title)
  end
end
