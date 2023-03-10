class BusinessTime < ApplicationRecord
  belongs_to :time_module
  validates :start, presence: true
  validates :_end, presence: true
  validates_time :start, :_end, invalid_time_message: 'Wrong Format'
end
