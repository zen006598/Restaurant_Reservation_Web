class Seat < ApplicationRecord
  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :deposit, numericality: { greater_than: -1 }

  enum :state, { empty: 0, occupy: 1 }, default: :empty
  enum :table_type, { regular_table: 0, private_room: 1, counter_seat: 2 }, default: :regular_table

end