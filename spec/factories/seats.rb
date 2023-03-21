FactoryBot.define do
  factory :seat do
    title { "MyString" }
    state { 1 }
    kind_of { 1 }
    capacity { 1 }
    restaurant { nil }
  end
end
