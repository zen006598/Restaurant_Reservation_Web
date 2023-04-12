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
  scope :exculde_arrival_times, -> (arrival_time) {where.not(arrival_time: arrival_time.map(&:to_time))}
  scope :search_arrival_date, ->(date) { where('DATE(arrival_time) = ?', date) }
  scope :people_sum, ->(people_sum) {where('adult_quantity + child_quantity = ?', people_sum)}
  scope :more_than_people_sum, ->(people_sum) {where('adult_quantity + child_quantity >= ?', people_sum)}

  after_save :get_unavailable_time

  def self.unavaliable_time_sha1(id, arrival_time, table_type)
    sha_id = Digest::SHA1.hexdigest(id.to_s.concat(arrival_time.strftime('%Y%m%d'), table_type.to_s))
    @@key = "unavailable_time:#{sha_id}"
  end

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
      set_unavailable_time(restaurant_id, arrival_time, table_type)
    end
  end

  def set_unavailable_time(restaurant_id, arrival_time, table_type)
    Reservation.unavaliable_time_sha1(restaurant_id, arrival_time, table_type)
    expire_time = (arrival_time.to_date.to_time + 1.days).to_i - Time.current.to_i
    $redis.expire(@@key, expire_time, nx: true)
    $redis.sadd(@@key, arrival_time)
  end
end