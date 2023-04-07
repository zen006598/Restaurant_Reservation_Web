class Seat < ApplicationRecord
  include TableType

  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  enum :state, { empty: 0, occupy: 1 }, default: :empty

  scope :table_count, -> (table_type) { where(table_type: table_type).count }
  
  def self.table_type_sum(table_type)
    table_count(table_type)
  end
end