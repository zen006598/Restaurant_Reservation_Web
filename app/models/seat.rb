class Seat < ApplicationRecord
  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  enum :state, {empty: 0, occupy: 1}, default: :empty
  
end