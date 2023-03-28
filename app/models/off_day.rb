class OffDay < ApplicationRecord
  has_many :restaurant_off_days, dependent: :destroy
  has_many :restaurants, through: :restaurant_off_days

  validates :day, presence: true, uniqueness: true
  validates_date :day, after: -> { Date.yesterday}

  scope :after_today, -> { where("day >= ?", Date.today) }
end
