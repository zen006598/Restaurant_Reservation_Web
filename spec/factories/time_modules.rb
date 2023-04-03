FactoryBot.define do
  factory :time_module do
    sequence(:title){|n| "Time00#{n}"}

    day_of_week_list {[]}
    association :restaurant
  end
end
