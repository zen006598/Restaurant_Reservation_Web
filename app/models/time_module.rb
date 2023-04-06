class TimeModule < ApplicationRecord
  include DayOfWeek
  belongs_to :restaurant
  has_many :business_times, inverse_of: :time_module, dependent: :destroy
  accepts_nested_attributes_for :business_times, allow_destroy: true

  before_validation :compact_params

  validates :title, presence: true
  validate :day_of_week_inclusion_validation, :repeat_with_other_business_day

  scope :except_time_module, -> (id) {where.not('time_modules.id = ?', id)}
  scope :in_which_time_module, -> (day_of_week) {
where('time_modules.day_of_week_list && array[?]', day_of_week)}

  def self.except_self(id)
    self.except_time_module(id).first
  end

  private

  def compact_params
    day_of_week_list&.compact!
  end

  def include_in_list?(list, attribute)
    if list.present? && attribute.present?
      attribute.each do |day|
        return true if list.include?(day)
      end
    end
    false
  end
    
  def repeat_with_other_business_day
    if day_of_week_list.present?
      business_times = restaurant.time_modules.except_self(self.id)&.day_of_week_list
      return errors.add(:day_of_week_list, :invalid) if include_in_list?(business_times, day_of_week_list)
    end
  end

  def day_of_week_inclusion_validation
    if day_of_week_list.present?
      day_of_week_list.each do |day|
        return errors.add(:day_of_week_list, :invalid) if DAYOFWEEK.values.exclude?(day)
      end
    end
  end
end
