class ReservationDate
  include DayOfWeek

  def initialize(off_days, time_modules, period_of_reservation = 365)
    @period_of_reservation = period_of_reservation
    @off_days = off_days.map(&:day)
    @time_modules = time_modules
    @date_range = (Date.today...Date.today + @period_of_reservation)

  end
  
  def disable_dates
    disable_day_of_week
    disable_dates = @date_range.to_a.select do |date|
      @disable_day_of_week.include?(date.wday)
    end
    @disable_dates = disable_dates.concat(@off_days)
  end

  def disable_day_of_week
    day_of_week = DAYOFWEEK.values
    enable_day_of_week = @time_modules.pluck(:day_of_week_list).flatten
    @disable_day_of_week = day_of_week - enable_day_of_week
  end

  def first_day
    disable_dates
    (@date_range.to_a - @disable_dates)[0]
  end

end

