FactoryBot.define do
  factory :reservation do 
    name { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    gender { 1 }
    comment { "MyText" }
    arrival_time { "2023-03-29 00:11:46" }
    state { 1 }
    adult_quantity { 1 }
    child_quantity { 1 }
    restaurant { nil }
  end
end
