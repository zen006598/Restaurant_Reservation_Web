class OffDay < ApplicationRecord
  has_many :restaurant_off_days, dependent: :destroy
  has_many :restaurants, through: :restaurant_off_days
end
