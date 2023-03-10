FactoryBot.define do
  factory :off_day do
    day { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
  end
end
