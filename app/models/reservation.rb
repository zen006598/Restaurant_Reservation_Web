class Reservation < ApplicationRecord
  include TableType

  belongs_to :restaurant

  validates :name, presence: true
  validates :phone, presence: true
  validates :gender, presence: true
  validates :arrival_time, presence: true
  validates :state, presence: true
  validates :adult_quantity, presence: true, numericality: { greater_than: 0 }
  validates :child_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_datetime :arrival_time
  validate :verify_arrival_time_in_business_time

  enum :gender, {male: 1, female: 2, other: 3}, default: :male

  scope :on_or_after_now, -> { where('arrival_time >= ?', Time.current)}
  scope :all_reservations, -> (restaurant_id){where('restaurant_id = ?', restaurant_id)}
  scope :except_canceled, -> {where.not(state: 'canceled')}
  scope :which_table_type, -> (table_type) {where('table_type = ?', table_type)}
  scope :when_arrival_time, -> (arrival_time) {where('arrival_time = ?', arrival_time)}

  after_save :get_unavailable_time

  private

  def verify_arrival_time_in_business_time
    day_of_week = arrival_time.wday
    time_module = restaurant.time_modules.in_which_time_module(day_of_week)
    interval_time = restaurant.interval_time

    business_times = BusinessTimeCounting.new(time_module, interval_time, arrival_time).reservable_time
    if business_times.exclude?(arrival_time.to_i)
      return errors.add(:arrival_time, 'The arrival time must in the business time.')
    end
  end

  def get_unavailable_time
    table_type = Reservation.table_types[self.table_type]
    reservations = Reservation.all_reservations(restaurant_id).except_canceled.which_table_type(table_type).when_arrival_time(arrival_time)

    table_type_maximun = restaurant.seats.table_count(table_type)
    reservations_number = reservations.size

    if table_type_maximun <= reservations_number
      sha_id = Digest::SHA1.hexdigest(restaurant_id.to_s)
      key = "unavailable_time:#{sha_id}:#{arrival_time.strftime('%Y%m%d')}"
      expire_time = (arrival_time.to_date.to_time + 1.days).to_i - Time.current.to_i
      # Grouping the unavailable_time in the same day
      # When the date for the unavailable time has passed, it will expire.
      $redis.expire(key, expire_time, nx: true)
      $redis.sadd(key, arrival_time)
    end
  end
end