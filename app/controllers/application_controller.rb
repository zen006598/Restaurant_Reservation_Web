class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    restaurant = current_user.restaurants.first
    current_user.owner? ? admin_restaurants_path : admin_restaurant_path(restaurant)
  end

  def render_flash
    turbo_stream.prepend('flash', partial: 'shared/flash')
  end

end
