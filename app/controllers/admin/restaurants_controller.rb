class Admin::RestaurantsController < Admin::ApplicationBackstageController
  load_and_authorize_resource except: :create
  
  before_action :find_restaurant, only: %i[show destroy edit destroy update setting off_day_setting]
  before_action :find_user, only: %i[index]

  layout 'application_restaurant', only: %i[show setting]
  
  def index
    @restaurants = current_user.restaurants.all
  end
  
  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.build(params_restaurant)
    if current_user.save
      redirect_to admin_restaurants_path(@restaurant), notice: "#{@restaurant.name} is successfully created"
    else
      render :new, alert: 'error'
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to admin_restaurants_path(@restaurant), notice: "#{@restaurant.name} is successfully edited"
    else
      render :new, alert: 'error'
    end
  end

  def destroy
    @destroy.destroy
    redirect_to admin_restaurants_path
  end

  def setting
    @time_module =  TimeModule.new
    @time_module.business_times.build
    @time_modules = @restaurant.time_modules

    @off_days = @restaurant.off_day_list
  end

  def off_day_setting
    if @restaurant.update(restaurant_params)
      redirect_to setting_admin_restaurant_path(@restaurant), notice: "Off day is successfully edited"
    else
      render :setting, alert: 'error'
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :tel, :address, :branch, :content, off_day_list: [])
  end

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def find_user
    @users = User.where(owner_id: current_user.id)
  end
end
