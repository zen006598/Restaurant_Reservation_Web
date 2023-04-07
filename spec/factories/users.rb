FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    password {'foobar123'}
    password_confirmation {'foobar123'}
    confirmed_at {Time.current}
    role {'owner'}
  end

  trait :manager do
    email {Faker::Internet.email}
    role {'manager'}
    owner_id {1}
  end

  trait :staff do
    email {Faker::Internet.email}
    role {'staff'}
    owner_id {1}
  end
end
