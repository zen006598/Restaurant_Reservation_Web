FactoryBot.define do
  factory :seat_module do
    association :restaurant
    title { "MyString" }
  end
end
