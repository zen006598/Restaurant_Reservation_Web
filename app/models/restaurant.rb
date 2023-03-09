class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :tel, presence: true,
                  uniqueness: true,
                  format: { with: /\A\d{2,3}-?|\(\d{2,3}\)\d{3,4}-?\d{4}\z/ }
  validates :branch, presence: true

  has_many :user_restaurants
  has_many :users, through: :user_restaurants
  has_many :time_modules, -> { includes :business_times }
  has_many :restaurant_off_days
  has_many :off_days, through: :restaurant_off_days

  has_rich_text :content

  OFFDAYOFWEEK = { Monday: 1, Tuesday: 2, Wednesday: 3,
                   Thursday: 4, Friday: 5, Saturday: 6,
                   Sunday: 0 }.freeze

  def off_day_list=(days)
    off_days << days.split(',').map do |day|
      OffDay.where(day: day.strip).first_or_create!
    end
  end
end
