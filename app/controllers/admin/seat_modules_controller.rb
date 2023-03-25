class Admin::SeatModulesController < ApplicationController
  layout 'application_backstage', only: %i[index]
  before_action :find_restaurant, only: %i[index create]
  before_action :find_seat_module, only: %i[edit update destroy show]

  def index
    @seat_modules = @restaurant.seat_modules.order(created_at: :asc)
    @seat_module = SeatModule.new
    @seat = Seat.new
  end

  def create 
    @seat_module = @restaurant.seat_modules.new(seat_module_params)
    respond_to do |format|
      if @seat_module.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('seat_module_form',
                                partial: "admin/seat_modules/form",
                                locals: {seat_module: @restaurant.seat_modules.new,
                                        url: admin_restaurant_seat_modules_path(@restaurant)}),
            turbo_stream.append('seat_modules',
                                partial: "admin/seat_modules/seat_module",
                                locals: {seat_module: @seat_module})]
        end
      else
        render :index, alert: 'error'
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.update(@seat_module, partial: "admin/seat_modules/form", locals: {seat_module: @seat_module, url: admin_seat_module_path(@seat_module)})
      end
    end
  end

  def show
    @seats = @seat_module.seats

    render turbo_stream: turbo_stream.replace(
      "seat_list",
      partial: "admin/seats/seats",
      locals: {
                seat: Seat.new,
                url: admin_seat_module_seats_path(@seat_module)
              }
    )
  end

  def update
    respond_to do |format|
      if @seat_module.update(seat_module_params)
        format.turbo_stream do 
          render turbo_stream: turbo_stream.update(@seat_module,
                                                    partial: "admin/seat_modules/seat_module",
                                                    locals: {seat_module: @seat_module})
        end
      else
        format.turbo_stream do 
          render turbo_stream: turbo_stream.update(@seat_module,
                                                    partial: "admin/seat_modules/form",
                                                    locals: {seat_module: @seat_module})
        end
      end
    end
  end

  def destroy
    @seat_module.destroy
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: [
          turbo_stream.remove(@seat_module),
          turbo_stream.after('seat_module_title', partial: "admin/seat_modules/delete", locals: {seat_module: @seat_module.title})
        ]
      end
    end
  end

  private
  
  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def seat_module_params
    params.require(:seat_module).permit(:title)
  end

  def find_seat_module
    @seat_module =  SeatModule.find(params[:id])
  end
end
