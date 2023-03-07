class RestaurantOffDay < ApplicationRecord
  belongs_to :restaurant
  belongs_to :off_day
end
