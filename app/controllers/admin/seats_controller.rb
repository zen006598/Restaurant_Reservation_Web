class Admin::SeatsController < Admin::ApplicationBackstageController
  before_action :find_seat_module, only: %i[create find_restaurant]
  before_action :find_restaurant, only: %i[create]
  before_action :find_seat, only: %i[destroy edit update]
  layout 'application_backstage'

  def create
    @seat = @seat_module.seats.new(seat_params)
    if @seat.save
      redirect_to admin_restaurant_seat_modules_path(@seat.restaurant),
      notice: "#{@seat.title} was successfully created"
    else
      redirect_back admin_restaurant_seat_modules_path(@seat.restaurant)
    end
  end

  def edit
    @restaurant = @seat.restaurant
  end

  def update
    if @seat.update(seat_params)
      redirect_to admin_restaurant_seat_modules_path(@seat.restaurant),
      notice: "#{@seat.title} was successfully edited"
    else
      redirect_back admin_restaurant_seat_modules_path(@seat.restaurant),
      notice: "#{@seat.errors.full_messages}"
    end
  end

  def destroy
    if @seat.destroy
      redirect_to admin_restaurant_seat_modules_path(@seat.restaurant),
      notice: "#{@seat.title} was removed"
    else
      redirect_back admin_restaurant_seat_modules_path(@seat.restaurant),
      notice: "#{@seat.errors.full_messages}"
    end
  end

  private

  def seat_params
    params.require(:seat).permit(:title, :state, :capacity).merge(restaurant: @restaurant)
  end

  def find_seat_module
    @seat_module = SeatModule.find(params[:seat_module_id])
  end

  def find_restaurant
    @restaurant = @seat_module.restaurant
  end

  def find_seat
    @seat = Seat.find(params[:id])
  end
end
