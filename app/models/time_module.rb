class TimeModule < ApplicationRecord
  include DayOfWeek
  belongs_to :restaurant
  has_many :business_times, inverse_of: :time_module, dependent: :destroy
  accepts_nested_attributes_for :business_times, allow_destroy: true

  validates :title, presence: true
  validate :day_of_week_inclusion_validation, :repeat_with_business_day, :repeat_with_off_days

  scope :except_self, -> (id) {where.not('time_modules.id = ?', id)}

  private

  def include_in_list?(list, attribute)
    list = list&.compact
    attribute = attribute&.compact
    if list.present? && attribute.present?
      attribute.each do |day|
        return true if list.include?(day)
      end
    end
    false
  end
    
  def repeat_with_business_day
    if day_of_week_list.present?
      business_times = restaurant.time_modules.except_self(self.id).pluck(:day_of_week_list).flatten.compact
      return errors.add(:day_of_week_list, :invalid) if include_in_list?(business_times, day_of_week_list)
    end
  end

  def repeat_with_off_days
    if restaurant&.off_day_of_week&.present?
      off_days = restaurant.off_day_of_week.compact
      return errors.add(:day_of_week_list, :invalid, 
message: 'Can not choice the off day') if include_in_list?(
off_days, day_of_week_list)
    end
  end

  def day_of_week_inclusion_validation
    if day_of_week_list.present?
      day_of_week_list&.compact.each do |day|
        return errors.add(:day_of_week_list, :invalid) if DayOfWeek::DAYOFWEEK.values.exclude?(day)
      end
    end
  end
end
