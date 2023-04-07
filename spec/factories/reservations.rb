FactoryBot.define do
  factory :reservation do 
    restaurant
    name { Faker::Name.name}
    phone { Faker::PhoneNumber.phone_number}
    email { Faker::Internet.email }
    gender { 1 }
    arrival_time { nil }
    adult_quantity { 1 }
    child_quantity { 1 }    

    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end

    before(:create) do |reservation|
      now = Time.current.strftime('%Y-%m-%d %H:%M').to_time.to_i
      _end = (now + 3.hours.to_i)

      reservation.arrival_time = Time.at((now .. _end).step(15.minutes).to_a.sample)
    end
  end
end

