class Admin::RestaurantsController < Admin::ApplicationBackstageController
  load_and_authorize_resource except: :create

  before_action :find_restaurant, only: %i[show destroy edit
                                           destroy update setting
                                           off_day_setting disabled_days]
  before_action :find_user, only: %i[index]

  layout 'application_backstage', only: %i[show setting]

  def index
    @restaurants = current_user.restaurants
  end

  def show; end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    if current_user.save
      redirect_to setting_admin_restaurant_path(@restaurant), notice: "#{@restaurant.name} is successfully created"
    else
      @restaurant.errors.full_messages.each { |message| flash.now.alert = "#{message}"}
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to admin_restaurants_path(@restaurant), notice: "#{@restaurant.name} is successfully edited"
    else
      @restaurant.errors.full_messages.each { |message| flash.now.alert = "#{message}"}
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  def setting
    @time_module = TimeModule.new
    @time_module.business_times.build
    @time_modules = @restaurant.time_modules

    # return off_day flatpickr
    @off_days = @restaurant.off_days
    disable_day_of_week = Restaurant::DAYOFWEEK.values - @restaurant.enable_day_of_week

    #  return time_modules new method be chioced day of week
    enable_day_of_week = @restaurant.enable_day_of_week

    respond_to do |format|
      format.json { render json: { _offDays: @off_days,
                                  disableDayOfWeek: disable_day_of_week,
                                  enableDay_of_week: enable_day_of_week} }
      format.html { render :setting }
    end
  end

  def off_day_setting
    if @restaurant.update(restaurant_params)
      redirect_to setting_admin_restaurant_path(@restaurant), notice: 'Off day is successfully created'
    else
      render :setting, alert: 'error'
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :tel, :address,
                                       :branch, :content, :off_day_list,
                                       :dining_time, :interval_time, :period_of_reservation,
                                       :deposit, :headcount_requirement)
  end

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def find_user
    @users = User.where(owner_id: current_user.id)
  end
end
