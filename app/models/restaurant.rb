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

  def enable_dates
    enable_day_of_week()
    reservable_range()
    off_dates()
    reservable_range = @reservable_range - @off_days
    reservable_date = reservable_range.select{ |date| @enable_day_of_week.include?(date.wday) }
  end

  def disable_dates
    enable_day_of_week()
    reservable_range()
    off_dates()
    disable_day_of_week = DAYOFWEEK.values - @enable_day_of_week
    unreservable_date = @reservable_range.select{ |date| disable_day_of_week.include?(date.wday) }
    unreservable_date.concat(@off_days).uniq
  end

  def enable_day_of_week
    @enable_day_of_week = time_modules.pluck(:day_of_week_list).uniq.flatten
  end
  
  def reservable_range
    @reservable_range = (Date.current .. Date.current + period_of_reservation.days).to_a
  end

  def off_dates
    @off_days = self.off_days.after_today.pluck(:day)
  end
end
