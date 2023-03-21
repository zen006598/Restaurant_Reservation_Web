class Seat < ApplicationRecord
  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true
  validates :is_open, presence: true

  enum :state, {empty: 0, occupy: 1}, default: :empty
end