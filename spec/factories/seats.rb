FactoryBot.define do
  factory :seat do
    association :restaurant
    association :seat_module
    sequence(:title){ |n| "seat-#{n}"}
    capacity { 10 }
    table_type {0}
  end
end
