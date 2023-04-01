class BusinessTimeCounting
  def initialize(day, time_module, interval_time)
    @day = day
    @time_module = time_module
    @interval_time = interval_time
  end

  def time_counting
    business_times = @time_module.business_times.map do |business_time|
      ("#{@day}-#{business_time.start.strftime('%R')}".to_time.to_i .. "#{@day}-#{business_time._end.strftime('%R')}".to_time.to_i).step(@interval_time).to_a
    end
    business_times.flatten
  end
end