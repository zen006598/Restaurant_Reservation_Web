class Seat < ApplicationRecord
  include TableType

  belongs_to :seat_module
  belongs_to :restaurant

  validates :title, presence: true
  validates :state, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }

  enum :state, { empty: 0, occupy: 1 }, default: :empty

  scope :table_count, -> (table_type) { where(table_type: table_type).count }
  scope :table_type, -> (table_type) { where(table_type: table_type) }
  scope :regular_table, -> { where(table_type: 0) }
  scope :private_room, -> { where(table_type: 1) }
  scope :counter_seat, -> { where(table_type: 2) }
  scope :capacity, -> (capacity){ where(capacity: capacity) }
  scope :more_than_capacity, -> (capacity){ where('capacity >= ?', capacity) }

  after_save :set_seats_info

  def self.sha1(restaurant_id)
    sha1 = Digest::SHA1.hexdigest("seats#{restaurant_id.to_s}")
    @@key = "seat:#{sha1}"
  end

  private

  def set_seats_info
    Seat.sha1(restaurant_id)
    quantity = restaurant.seats.table_count(self.table_type)
    table_type = self.table_type.to_sym
    maximum_capacity = restaurant.seats.maximum(:capacity)

    set_maximum_capacity(@@key, maximum_capacity)
    set_table_type_number(@@key, table_type, quantity)
    $redis.expire(@@key, 30.days)
  end

  def set_maximum_capacity(key, maximum_capacity)
    $redis.hset(key, :maximum_capacity, maximum_capacity)
  end

  def set_table_type_number(key, table_type, quantity)
    $redis.hset(key, table_type, quantity)
  end
end
