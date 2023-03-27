class Admin::SeatsController < Admin::ApplicationBackstageController
  before_action :find_seat_module, only: %i[create find_restaurant new]
  before_action :find_restaurant, only: %i[create]
  before_action :find_seat, only: %i[destroy edit update close]

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
                                locals: {seat: @seat}),
            turbo_stream.update(@seat_module,
                                partial: 'admin/seat_modules/seat_module',
                                locals: {seat_module: @seat_module})]
        end
      end
    end

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update('seat_new_form', partial: 'admin/seats/form',
                                                  locals: {seat: @seat_module.seats.new, 
                                                          url: admin_seat_module_seats_path(@seat_module)})}
    end

  end

  def edit
    render_edit
  end

  def update
    if @seat.update(seat_params)
      respond_to do |format|
        format.turbo_stream {render turbo_stream: turbo_stream.update(@seat, 
                                                                      partial: "admin/seats/seat", 
                                                                      locals: {seat: @seat})}
      end
    else
      render_edit
    end
  end

  def destroy
    @seats = @seat.seat_module.seats
    if @seat.destroy
      respond_to do |format|
        format.turbo_stream {render turbo_stream: turbo_stream.update('seat_field',
                                                                      partial: "admin/seats/seat", 
                                                                      collection: @seats)}
      end
    end
  end

  def close
    render turbo_stream: turbo_stream.replace(@seat, partial: "admin/seats/seat", locals: {seat: @seat})
  end

  private

  def seat_params
    params.require(:seat).permit(:title, :state, :capacity, :restaurant_id).tap do |params|
      params.delete(:restaurant_id) if action_name == 'create'
    end
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

  def render_edit
    render turbo_stream: turbo_stream.update(@seat, 
                                              partial: "admin/seats/edit", 
                                              locals: {seat: @seat, url: admin_seat_path(@seat)})
  end
end
