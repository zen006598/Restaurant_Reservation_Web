class Admin::SeatsController < Admin::ApplicationBackstageController
  before_action :find_seat_module, only: %i[create find_restaurant new]
  before_action :find_restaurant, only: %i[create]
  before_action :find_seat, only: %i[destroy edit update close]

  def new
    @seat = Seat.new
    render turbo_stream: render_form(@seat, admin_seat_module_seats_path(@seat_module))
  end

  def create
    @seat = @seat_module.seats.new(seat_params)
    respond_to do |format|
      if @seat.save
        flash[:notice] = "#{@seat_module.title} successfully created"
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('seat_field',
                                partial: 'admin/seats/seat', locals: {seat: @seat}),
            turbo_stream.update(@seat_module,
                                partial: 'admin/seat_modules/seat_module', locals: {seat_module: @seat_module}),
            render_form(Seat.new, admin_seat_module_seats_path(@seat_module)),
            render_flash]
        end
      else
        @seat.errors.full_messages.each {|message| flash[:alert] = "#{message}"}
        format.turbo_stream do
          render turbo_stream: [
            render_form(Seat.new, admin_seat_module_seats_path(@seat_module)), render_flash]
        end
      end
    end
  end

  def edit
    render turbo_stream: render_edit
  end

  def update
    respond_to do |format|
      if @seat.update(seat_params)
          format.turbo_stream {render turbo_stream: turbo_stream.update(@seat, 
                                                                        partial: "admin/seats/seat", 
                                                                        locals: {seat: @seat})}
      else
        @seat.errors.full_messages.each {|message| flash[:alert] = "#{message}"}
        format.turbo_stream{ render turbo_stream: [render_edit, render_flash] }
      end
    end
  end

  def destroy
    @seats = @seat.seat_module.seats
    if @seat.destroy
      flash[:alert] = "#{@seat.title} was removed."
      respond_to do |format|
        format.turbo_stream {render turbo_stream: [
          turbo_stream.update('seat_field',partial: "admin/seats/seat", collection: @seats), render_flash]
        }
      end
    end
  end

  def close
    render turbo_stream: turbo_stream.replace(@seat, partial: "admin/seats/seat", locals: {seat: @seat})
  end

  private

  def seat_params
    return params.require(:seat).permit(:title, :state, :capacity, :table_type) if params[:action] == 'update'

    params.require(:seat).permit(:title, :state, :capacity, :table_type).merge(restaurant: @restaurant)
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
    turbo_stream.update(@seat, partial: "admin/seats/edit", 
                                locals: {seat: @seat, 
                                          url: admin_seat_path(@seat)})
  end

  def render_form(params, url)
    turbo_stream.replace('seat_new_form', partial: 'admin/seats/form',
                                          locals: {seat: params, url: url})
  end
end
