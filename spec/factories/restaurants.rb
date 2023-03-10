FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    address { "#{Faker::Address.street_name} #{Faker::Address.community}"}
    tel { '02-5577-1111' }
    branch { Faker::Address.community }
  end
end
