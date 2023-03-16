class Admin::TimeModulesController < Admin::ApplicationBackstageController
  before_action :find_restaurant, only: %i[create]
  before_action :find_time_module, only: %i[destroy edit update]
  def create
    @time_module = @restaurant.time_modules.new(time_module_params)
    if @time_module.save
      redirect_to setting_admin_restaurant_path(@time_module.restaurant_id),
      notice: "#{@time_module.title} successfully created."
    else
      redirect_to setting_admin_restaurant_path(@restaurant), 
      notice: "#{@time_module.errors.full_messages}"
    end
  end

  def edit
    @restaurant = @time_module.restaurant
  end 

  def update
    if @time_module.update(time_module_params)
      redirect_to setting_admin_restaurant_path(@time_module.restaurant_id),
      notice: "#{@time_module.title} successfully updated."
    else
      redirect_to setting_admin_restaurant_path(@time_module.restaurant_id),
      notice: "#{@time_module.errors.full_messages}"
    end
  end

  def destroy
    @time_module.destroy
    redirect_to setting_admin_restaurant_path(@time_module.restaurant_id)
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
