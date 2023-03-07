class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :tel, presence: true, uniqueness: true, format: {with: /\d{2,3}-?|\(\d{2,3}\)\d{3,4}-?\d{4}/ }
  validates :branch, presence: true

  has_many :user_restaurants
  has_many :users, through: :user_restaurants
  has_many :time_modules
  # has_many :restaurant_off_days
  # has_many :off_days, through: :restaurant_off_days

  has_rich_text :content

  # def off_day_list=(days)
  #   self.off_days = days.map do |item|
  #     OffDay.where(day: item).first_or_create! if !item.empty?
  #   end.compact!
  # end

  # def off_day_list
  #   off_days.map(&:day)
  # end
end
