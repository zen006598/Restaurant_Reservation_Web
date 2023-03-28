class Restaurant < ApplicationRecord
  include DayOfWeek

  validates :name, presence: true
  validates :address, presence: true
  validates :tel, presence: true,
                  uniqueness: true,
                  format: { with: /\A(\d{2,3}-?|\d{2,3})\d{3,4}-?\d{4}\z/,
                            message: 'invalid format'
                          }
  validate :off_day_of_week_inclusion_validation

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

  private

  def off_day_of_week_inclusion_validation
    if off_day_of_week.present?
      off_day_of_week&.compact.each do |day|
          return errors.add(:off_day_of_week, :invalid) if DayOfWeek::DAYOFWEEK.values.exclude?(day)
        end
    end
  end
end
