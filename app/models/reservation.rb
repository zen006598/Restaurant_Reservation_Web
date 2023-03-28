class Reservation < ApplicationRecord
  belongs_to :restaurant
  validates :serial, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :gender, presence: true
  validates :arrival_time, presence: true
  validates :state, presence: true
  validates :adult_quantity, presence: true, numericality: { greater_than: 0 }
  validates :child_quantity, presence: true, numericality: { greater_than: -1 }
  validates_datetime :arrival_time
end
