module DayOfWeek
  extend ActiveSupport::Concern

  DAYOFWEEK = { Monday: 1, Tuesday: 2, Wednesday: 3,
    Thursday: 4, Friday: 5, Saturday: 6,
    Sunday: 0 }.freeze
    
end