class Admin::SeatModulesController < ApplicationController
  layout 'application_backstage', only: %i[index]
  before_action :find_restaurant, only: %i[index create]
  before_action :find_seat_module, only: %i[edit update destroy show]

  def index
    @seat_modules = @restaurant.seat_modules
    @seat_module = SeatModule.new
    @seat = Seat.new
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

  def show
    render json: {seat_module: @seat_module.title, seat_module_id: @seat_module.id , seats: @seat_module.seats}
  end

  def update
    if @seat_module.update(seat_modules_params)
      redirect_to admin_restaurant_seat_modules_path(@seat_module.restaurant)
    else
      render :index, alert: 'error'
    end
  end

  def destroy
  end

  private
  
  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def seat_modules_params
    params.require(:seat_module).permit(:title)
  end

  def find_seat_module
    @seat_module =  SeatModule.find(params[:id])
  end
end
