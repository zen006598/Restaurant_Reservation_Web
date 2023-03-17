FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    address { "#{Faker::Address.street_name} #{Faker::Address.community}"}
    tel { '02-5577-1111' }
    branch { Faker::Address.community }
    off_day_of_week {DayOfWeek::DAYOFWEEK.to_a.sample[-1].digits}
  end
end