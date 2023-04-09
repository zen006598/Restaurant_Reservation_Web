class Seat < ApplicationRecord
  include TableType

  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  enum :state, { empty: 0, occupy: 1 }, default: :empty

  scope :table_count, -> (table_type) { where(table_type: table_type).count }
  scope :regular_table_count, -> { where(table_type: 0).count }
  scope :private_room_count, -> { where(table_type: 1).count }
  scope :counter_seat_count, -> { where(table_type: 2).count }
  
  def self.table_type_sum(table_type)
    table_count(table_type)
  end
end