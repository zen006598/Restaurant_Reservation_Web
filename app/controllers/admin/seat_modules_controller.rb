class Admin::SeatModulesController < Admin::ApplicationBackstageController
  layout 'application_backstage', only: %i[index]
  before_action :find_restaurant, only: %i[index create re_render]
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
        flash[:notice] = "#{@seat_module.title} successfully created"
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update('seat_module_form',
                                partial: "admin/seat_modules/form",
                                locals: {seat_module: @restaurant.seat_modules.new,
                                        url: admin_restaurant_seat_modules_path(@restaurant)}),
            turbo_stream.append('seat_modules',
                                partial: "admin/seat_modules/seat_module",
                                locals: {seat_module: @seat_module}),      
            render_flash]
        end
      else
        flash[:alert] = "errors"
        render_flash
      end
    end
  end

  def edit
    respond_to { |format| format.turbo_stream { render_form } }
  end

  def show
    @seats = @seat_module.seats
    render turbo_stream: turbo_stream.replace("seat_list", partial: "admin/seats/seats")
  end

  def update
    respond_to do |format|
      if @seat_module.update(seat_module_params)
        flash[:notice] = "#{@seat_module.title} successfully edited."
        format.turbo_stream do 
          render turbo_stream: [
            turbo_stream.update(@seat_module, partial: "admin/seat_modules/seat_module", 
locals: {seat_module: @seat_module}),
            render_flash
          ]
        end
      else
        format.turbo_stream do 
          render_form
        end
      end
    end
  end

  def destroy
    @seat_module.destroy
    respond_to do |format|
      flash[:alert] = "#{@seat_module.title} was removed."
      format.turbo_stream do
        render turbo_stream: [turbo_stream.remove(@seat_module), render_flash]
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

  def render_form
    render turbo_stream: turbo_stream.update(@seat_module, 
                                              partial: "admin/seat_modules/form",
                                              locals: {seat_module: @seat_module, 
url: admin_seat_module_path(@seat_module)})
  end
end
