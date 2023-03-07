class Admin::UsersController < Admin::ApplicationBackstageController
  load_and_authorize_resource
  
  before_action :find_restaurant, only: %i[assign_restaurants]
  before_action :find_staff, only: %i[assign_restaurants show]

  def show
    @restaurants = current_user.restaurants
  end

  def assign_restaurants
    @staff.restaurants << @restaurant
    redirect_to admin_user_path(@staff)
  end

  private
  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurants])
  end

  def find_staff
    @staff = User.find(params[:id])
  end
end
