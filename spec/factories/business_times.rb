FactoryBot.define do
  factory :business_time do
    time_module
    start { "#{Time.current}" }
    _end { "#{Time.current + 3.hour}"}
  end
end
