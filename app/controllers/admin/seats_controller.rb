class Admin::SeatsController < Admin::ApplicationBackstageController
  before_action :find_seat_module, only: %i[create find_restaurant new]
  before_action :find_restaurant, only: %i[create]
  before_action :find_seat, only: %i[destroy edit update]

  def new
    @seat = Seat.new
    render turbo_stream: turbo_stream.replace(
      "seat_new_form",
      partial: "admin/seats/form",
      locals: {
                seat: @seat,
                url: admin_seat_module_seats_path(@seat_module)
              }
    )
  end

  def create
    @seat = @seat_module.seats.new(seat_params)
    if @seat.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('seat_field',
                                partial: 'admin/seats/seat',
                                locals: {seat: @seat}
                                ),
            turbo_stream.update('seat_new_form',
                                partial: 'admin/seats/form',
                                locals: {seat: @seat_module.seats.new,
                                        url: admin_seat_module_seats_path(@seat_module)}
                                )
            ]
        end
      end
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
