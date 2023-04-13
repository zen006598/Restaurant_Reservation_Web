unless Rails.env.test?
  $redis = Redis.new(url: "redis://localhost:6379/")
else
  $redis = MockRedis.new
end