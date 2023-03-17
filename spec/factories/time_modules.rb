FactoryBot.define do
  factory :time_module do
    title { 'Time01' }
    day_of_week_list {[]}
    association :restaurant
  end
end
