class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :tel, presence: true, uniqueness: true, format: {with: /\d{2,3}-?|\(\d{2,3}\)\d{3,4}-?\d{4}/ }
  validates :branch, presence: true

  has_many :user_restaurants
  has_many :users, through: :user_restaurants
  has_many :time_modules, ->{includes :business_times}
  has_many :restaurant_off_days
  has_many :off_days, through: :restaurant_off_days

  has_rich_text :content

  OFFDAYOFWEEK = {Monday: 1, Tuesday: 2, Wednesday: 3, Thursday:4 ,Friday: 5,Saturday: 6, Sunday: 0}

  def off_day_list=(day)
    self.off_days << OffDay.find_or_create_by!(day: day)
  end

  def off_day_list
    off_days.map(&:day)
  end
end
