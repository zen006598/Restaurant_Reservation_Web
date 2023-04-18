class Reservation < ApplicationRecord
  include TableType
  include AASM
  # assoccation
  belongs_to :restaurant
  # validation
  validates :name, presence: true
  validates :phone, presence: true
  validates :gender, presence: true
  validates :arrival_time, presence: true
  validates :state, presence: true
  validates :adult_quantity, presence: true, numericality: { greater_than: 0 }
  validates :child_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_datetime :arrival_time
  validate :verify_arrival_time_in_business_time, :verify_capacity_validation
  # enum
  enum :gender, {male: 1, female: 2, other: 3}, default: :male
  # scope
  scope :on_or_after_now, -> { where('arrival_time >= ?', Time.current)}
  scope :except_canceled, -> {where.not(state: 'canceled')}
  scope :which_table_type, -> (table_type) {where('table_type = ?', table_type)}
  scope :exculde_arrival_times, -> (arrival_time) {where.not(arrival_time: arrival_time.map(&:to_time))}
  scope :search_arrival_date, ->(date) { where('DATE(arrival_time) = ?', date) }
  scope :people_sum, ->(people_sum) {where('adult_quantity + child_quantity = ?', people_sum)}
  scope :more_than_people_sum, ->(people_sum) {where('adult_quantity + child_quantity >= ?', people_sum)}
  # callback
  after_save :get_unavailable_times
  # class method
  def self.unavaliable_time_sha1(id, arrival_time, table_type)
    sha_id = Digest::SHA1.hexdigest(id.to_s.concat(arrival_time.strftime('%Y%m%d'), table_type.to_s))
    @@key = "unavailable_time:#{sha_id}"
  end
  # aasm
  aasm column: 'state', no_direct_assignment: true  do
    state :reservated, initial: true
    state :pending, :complete, :canceled

    event :reservate do
      transitions from: :pending, to: :reservated
    end

    event :complete do
      transitions from: :reservated, to: :complete
    end

    event :cancel do
      transitions from: %i[reservated pending], to: :canceled
    end
  end

  private

  # custom validation
  def verify_arrival_time_in_business_time
    day_of_week = arrival_time.wday
    time_module = restaurant.time_modules.in_which_time_module(day_of_week)
    business_times = time_module.available_reservable_time(arrival_time)

    if business_times.exclude?(arrival_time.to_i)
      return errors.add(:arrival_time, 'The arrival time must in the business time.')
    end
  end

  def verify_capacity_validation
    table_type = Reservation.table_types[self.table_type]
    reservations_number = get_reservations_quantity(restaurant_id, table_type, arrival_time)
    table_quantity = get_table_quantity(restaurant_id, self.table_type)

    return errors.add(:arrival_time, 'The selected time is full.') if reservations_number >= table_quantity
  end

  # callback
  def get_unavailable_times
    table_type = Reservation.table_types[self.table_type]
    reservations_number = get_reservations_quantity(restaurant_id, table_type, arrival_time)
    table_quantity = get_table_quantity(restaurant_id, self.table_type)

    return if table_quantity > reservations_number

    set_unavailable_times(restaurant_id, arrival_time, table_type)
  end

  def set_unavailable_times(restaurant_id, arrival_time, table_type)
    Reservation.unavaliable_time_sha1(restaurant_id, arrival_time, table_type)
    expire_time = (arrival_time.to_date.to_time + 1.days).to_i - Time.current.to_i

    if $redis.smembers(@@key).present?
      $redis.sadd(@@key, arrival_time)
    else
      $redis.sadd(@@key, arrival_time)
      $redis.expire(@@key, expire_time)
    end
  end

  def get_reservations_quantity(restaurant_id, table_type, arrival_time)
    Reservation.where(restaurant_id: restaurant_id,
                      table_type: table_type,
                      arrival_time: arrival_time).except_canceled.size
  end
  
  def get_table_quantity(restaurant_id, table_type)
    key = Seat.sha1(restaurant_id)
    $redis.hget(key, table_type).to_i
  end
end

