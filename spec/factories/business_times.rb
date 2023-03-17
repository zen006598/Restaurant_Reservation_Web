FactoryBot.define do
  factory :business_time do
    start { "#{Time.now}" }
    _end { "#{Time.now + 1.hour}"}
    association :time_module
  end
end
