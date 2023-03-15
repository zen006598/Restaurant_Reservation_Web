class TimeModule < ApplicationRecord
  include DayOfWeek
  belongs_to :restaurant
  has_many :business_times, inverse_of: :time_module, dependent: :destroy
  accepts_nested_attributes_for :business_times, allow_destroy: true

  validates :title, presence: true
  validate :set_business_time_vaildation, on: :create
  validates :day_of_week_list, inclusion: {in: DAYOFWEEK.values}

  private
    
  def set_business_time_vaildation
    debugger
    off_days = restaurant.off_day_of_week.compact!
    business_times = restaurant.time_modules.pluck(:day_of_week_list).pop&.flatten

    day_of_week_list.compact!.each do |day|
      return errors.add(:day_of_week_list, :invalid) if off_days.include?(day)
    end

    if !business_times.nil?
      day_of_week_list.compact.each do |day|
        return errors.add(:day_of_week_list, :invalid) if business_times.include?(day)
      end
    end
 
  end
end
