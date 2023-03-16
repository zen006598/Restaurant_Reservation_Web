class TimeModule < ApplicationRecord
  include DayOfWeek
  belongs_to :restaurant
  has_many :business_times, inverse_of: :time_module, dependent: :destroy
  accepts_nested_attributes_for :business_times, allow_destroy: true

  validates :title, presence: true
  validate :day_of_week_inclusion_validation, :set_business_time_vaildation

  scope :except_self, -> (id) {where.not('time_modules.id = ?', id)}

  private
    
  def set_business_time_vaildation
    off_days = restaurant.off_day_of_week.compact
    business_times = restaurant.time_modules.except_self(self.id).pluck(:day_of_week_list).flatten.compact

    day_of_week_list.each do |day|
      return errors.add(:day_of_week_list, :invalid) if off_days.include?(day)
    end

    if !business_times.nil?
      day_of_week_list.compact.each do |day|
        return errors.add(:day_of_week_list, :invalid) if business_times.include?(day)
      end
    end
  end

  def day_of_week_inclusion_validation
    day_of_week_list.compact.each do |day|
      return errors.add(:day_of_week_list, :invalid) if DAYOFWEEK.values.exclude?(day)
    end
  end

end
