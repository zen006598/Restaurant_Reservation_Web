class Restaurant < ApplicationRecord
  include DayOfWeek

  validates :name, presence: true
  validates :address, presence: true
  validates :tel, presence: true,
                  uniqueness: true,
                  format: { with: /\A(\d{2,3}-?|\d{2,3})\d{3,4}-?\d{4}\z/,
                            message: 'invalid format'
                          }
  validates :off_day_of_week, inclusion: {in: DAYOFWEEK}

  has_many :user_restaurants
  has_many :users, through: :user_restaurants
  has_many :time_modules, -> { includes :business_times }
  has_many :restaurant_off_days
  has_many :off_days, through: :restaurant_off_days
  has_rich_text :content

  def off_day_list=(days)
    off_days << days.split(',').map do |day|
      OffDay.where(day: day.strip).first_or_create!
    end
  end
end
