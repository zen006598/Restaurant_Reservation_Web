class SeatModule < ApplicationRecord
  belongs_to :restaurant
  has_many :seats

  validates :title, presence: true
end
