class Seat < ApplicationRecord
  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true }
  validate :verify_capacity

  enum :state, {empty: 0, occupy: 1}, default: :empty

  private

  def verify_capacity
    return errors.add(:capacity, 'The capacity must not be less than 1.') if capacity < 1
  end
  
end