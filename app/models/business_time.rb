class BusinessTime < ApplicationRecord
  belongs_to :time_module
  validates :start, presence: true
  validates :_end, presence: true
end
