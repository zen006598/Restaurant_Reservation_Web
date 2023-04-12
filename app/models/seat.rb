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

  after_save :maximum_capacity
  
  def self.table_type_sum(table_type)
    table_count(table_type)
  end

  def self.maximum_capacity_sha1(restaurant_id)
    sha1 = Digest::SHA1.hexdigest("seats#{restaurant_id.to_s}")
    @@key = "seat:#{sha1}"
  end

  private

  def maximum_capacity
    Seat.maximum_capacity_sha1(restaurant_id)
    maximum_capacity = restaurant.seats.maximum(:capacity)
    set_maximum_capacity(@@key, maximum_capacity)
  end

  def set_maximum_capacity(key, maximum_capacity)
    $redis.hset(key, :maximum_capacity, maximum_capacity)
    $redis.expire(key, 30.days)
  end
end
