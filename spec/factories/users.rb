FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    password {'foobar123'}
    password_confirmation {'foobar123'}
    confirmed_at {Time.current}
    name {Faker::Name.name}
    role {'owner'}
  end
end
