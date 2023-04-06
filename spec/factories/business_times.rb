FactoryBot.define do
  factory :business_time do
    time_module

    start { "#{Time.now}" }
    _end { "#{Time.now + 3.hour}"}
  end
end
