FactoryBot.define do  
  factory :restaurant do
    sequence(:name){ |n| "#{Faker::Restaurant.name}-#{n}"}
    sequence(:tel){ |n| "02-5577-111#{n}"}
    address { "#{Faker::Address.street_name} #{Faker::Address.community}"}
    branch { Faker::Address.community }
  end
end