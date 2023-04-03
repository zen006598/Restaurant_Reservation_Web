class Reservation < ApplicationRecord
  belongs_to :restaurant

  validate :verify_arrival_time_inclusion, :verify_reservation_date
  validates :name, presence: true
  validates :phone, presence: true
  validates :gender, presence: true
  validates :arrival_time, presence: true
  validates :state, presence: true
  validates :adult_quantity, presence: true, numericality: { greater_than: 0 }
  validates :child_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_datetime :arrival_time

  enum :gender, {male: 1, female: 2, other: 3}, default: :male

  private

  def verify_arrival_time_inclusion
    day_of_week = arrival_time.to_date.wday
    day = arrival_time.to_date
    time_module = restaurant.time_modules.in_which_time_module(day_of_week).first
    interval_time = restaurant.interval_time.minutes

    business_times = BusinessTimeCounting.new(day, time_module, interval_time).time_counting

    return errors.add(:arrival_time, 'The arrival time must in the business time.') if business_times.exclude?(arrival_time.to_time.to_i)
  end

  def verify_reservation_date
    enable_day = ReservationDate.new(restaurant.period_of_reservation, restaurant.off_day_of_week, restaurant.off_days.after_today).business_days
    arrival_day = arrival_time.to_date

    return errors.add(:arrival_time, 'The arrival time must in the business day.') if enable_day.exclude?(arrival_day)
  end

end