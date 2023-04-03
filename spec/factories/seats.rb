FactoryBot.define do
  factory :seat do
    association :restaurant
    association :seat_module
    title { "seat001" } 
    capacity { 10 }
  end
end
