class Admin::OffDaysController < Admin::ApplicationBackstageController
  before_action :find_off_day

  def destroy
    restaurant = @off_day.restaurants.first
    restaurant.off_days.delete(@off_day)
    redirect_to setting_admin_restaurant_path(restaurant)
  end

  private

  def find_off_day
    @off_day = OffDay.find(params[:id])
  end
end
