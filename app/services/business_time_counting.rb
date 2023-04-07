class BusinessTimeCounting
  def initialize(time_module, interval_time, day = Time.current)
    @time_module = time_module
    @interval_time = interval_time.minutes
    @day = day.strftime('%Y-%m-%d')
  end

  def reservable_time
    reservable_times = @time_module.business_times.map do |business_time|
      start = "#{@day} #{business_time.start.strftime('%R')}".in_time_zone.to_i
      _end = "#{@day} #{business_time._end.strftime('%R')}".in_time_zone.to_i
      (start.._end).step(@interval_time).to_a
    end

    reservable_times.flatten
  end
end