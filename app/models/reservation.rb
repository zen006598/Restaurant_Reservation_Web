class Reservation < ApplicationRecord
  belongs_to :restaurant

  validates :name, presence: true
  validates :phone, presence: true
  validates :gender, presence: true
  validates :arrival_time, presence: true
  validates :state, presence: true
  validates :adult_quantity, presence: true, numericality: { greater_than: 0 }
  validates :child_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_datetime :arrival_time
  validate :verify_arrival_time_in_business_day, :verify_arrival_time_in_business_time

  enum :gender, {male: 1, female: 2, other: 3}, default: :male

  private

  def verify_arrival_time_in_business_time
    day_of_week = arrival_time.wday
    time_module = restaurant.time_modules.in_which_time_module(day_of_week).first
    interval_time = restaurant.interval_time

    business_times = BusinessTimeCounting.new(time_module, interval_time).time_counting

    if business_times.exclude?(arrival_time.strftime('%R').to_time.to_i)
      return errors.add(:arrival_time, 'The arrival time must in the business time.') 
    end
  end

  def verify_arrival_time_in_business_day
    enable_day = ReservationDate.new(restaurant.off_days, 
                                    restaurant.time_modules,
                                    restaurant.period_of_reservation).enable_dates
    arrival_day = arrival_time.to_date
    return errors.add(:arrival_time, 
                      'The arrival time must in the business day.') if enable_day.exclude?(arrival_day)
  end
end