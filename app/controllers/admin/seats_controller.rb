class Admin::SeatsController < Admin::ApplicationBackstageController
  before_action :find_restaurant, only: %i[index create]
  layout 'application_backstage'
  
  def index
    @seats = @restaurant.seats
    @seat = Seat.new
  end

  def create

    @seat = @restaurant.seats.new(seat_params)
    if @seat.save
      redirect_to admin_restaurant_seats_path(@restaurant),
      notice: "#{@seat.title} was successfully created"
    else
      render :index, notice: "#{@seat.errors.full_messages}"
    end
  end

  def edit
  end

  private

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def seat_params
    params.require(:seat).permit(:title, :state, :kind_of, :capacity, :is_open)
  end
end
