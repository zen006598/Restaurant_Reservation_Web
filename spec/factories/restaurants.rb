FactoryBot.define do  
  factory :restaurant do
    sequence(:name){ |n| "#{Faker::Restaurant.name}-#{n}"}
    sequence(:tel, ('001'..'100').cycle){ |n| "02-5577-1#{n}"}

    address { "#{Faker::Address.street_name} #{Faker::Address.community}"}
    branch { Faker::Address.community }
    period_of_reservation {rand(7..30)}
    interval_time{15}
    dining_time {120}

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end
end
