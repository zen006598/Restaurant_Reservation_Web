class Restaurant < ApplicationRecord
  include DayOfWeek
  
  validates :name, presence: true
  validates :address, presence: true
  validates :dining_time, numericality: { greater_than_or_equal_to: 0 }
  validates :interval_time, numericality: { greater_than_or_equal_to: 0 }
  validates :period_of_reservation, numericality: { greater_than_or_equal_to: 0 }
  validates :deposit, numericality: { greater_than_or_equal_to: 0 }
  validates :tel, presence: true,
                  uniqueness: true,
                  format: { with: /\A(\d{2,3}-?|\d{2,3})\d{3,4}-?\d{4}\z/,
                            message: 'invalid format'
                          }

  has_many :user_restaurants
  has_many :users, through: :user_restaurants
  has_many :time_modules, -> { includes :business_times }
  has_many :restaurant_off_days
  has_many :off_days, through: :restaurant_off_days
  has_many :seat_modules
  has_many :seats
  has_many :reservations
  has_rich_text :content

  def off_day_list=(days)
    off_days << days.split(',').map do |day|
      OffDay.where(day: day.strip).first_or_create!
    end
  end
end

