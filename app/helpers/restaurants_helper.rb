module RestaurantsHelper
  class ReservationDate
    def initialize(period_of_reservation, off_day_of_week, off_days)
      @period_of_reservation = period_of_reservation
      @off_day_of_week = off_day_of_week.compact
      @off_days = off_days.map(&:day)
    end
    
    def business_days
      dates = (Date.today...Date.today + @period_of_reservation).to_a
      off_days = dates.select { |date| @off_day_of_week.include?(date.wday) }.concat(@off_days)
      business_days = dates - off_days
    end
  end
end
