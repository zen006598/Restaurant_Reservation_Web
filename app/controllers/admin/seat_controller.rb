class Admin::SeatController < Admin::ApplicationBackstageController
  before_action :find_restaurant, only: %i[index]
  layout 'application_backstage'
  
  def index
  end

  def edit
  end

  private

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end
end
class Admin::SeatController < Admin::ApplicationBackstageController
  before_action :find_restaurant, only: %i[index]
  layout 'application_backstage'
  
  def index
  end

  def edit
  end

  private

  def find_restaurant
    @restaurant = current_user.restaurants.find(params[:restaurant_id])
  end
end
