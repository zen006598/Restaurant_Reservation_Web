class Admin::TimeModulesController < Admin::ApplicationBackstageController
  before_action :find_restaurant, only: %i[create]
  before_action :find_time_module, only: %i[destroy edit update]

  def create
    @time_module = @restaurant.time_modules.new(time_module_params)
    if @time_module.save
      redirect_to setting_admin_restaurant_path(@time_module.restaurant_id),
      notice: "#{@time_module.title} successfully created."
    else
      redirect_to setting_admin_restaurant_path(@restaurant)
    end
  end

  def edit
    @restaurant = @time_module.restaurant
  end 

  def update
    respond_to do |format|
      if @time_module.update(time_module_params)
        flash[:notice] = "#{@time_module.title} successfully edited."
        format.turbo_stream do render turbo_stream: [
          turbo_stream.update(@time_module, partial: "admin/time_modules/time_module", 
                                            locals: {time_module: @time_module}), render_flash]
        end
      else
        @time_module.errors.full_messages.each {|message| flash[:alert] = "#{message}"}

        format.turbo_stream do 
          render turbo_stream: [
            turbo_stream.update(@time_module, 
                                partial: "admin/time_modules/form",
                                locals: {time_module: @time_module, 
                                        url: admin_time_module_path(@time_module)}), render_flash]
        end
      end
    end
  end

  def destroy
    @time_module.destroy
    respond_to {|format| format.turbo_stream {render turbo_stream: turbo_stream.remove(@time_module)} }
  end

  private

  def time_module_params
    params.require(:time_module).permit(:title, day_of_week_list: [], 
                                        business_times_attributes: %i[id start _end])
  end

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end

  def find_time_module
    @time_module = TimeModule.find(params[:id])
  end
end
