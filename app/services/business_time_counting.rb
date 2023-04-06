class BusinessTimeCounting
  def initialize(time_module, interval_time)
    @time_module = time_module
    @interval_time = interval_time.minutes
  end

  def time_counting
    business_times = @time_module.business_times.map do |business_time|
      time_difference = business_time._end.to_time - business_time.start.to_time

      start = business_time.start.strftime('%R').to_time.to_i
      _end = start + time_difference
      (start.._end).step(@interval_time).to_a
    end

    business_times.flatten
  end
end