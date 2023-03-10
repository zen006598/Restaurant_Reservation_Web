user = User.new({ email: ENV['EMAIL'], password: '111111', password_confirmation: '111111', role: 'owner' })
user.skip_confirmation!
user.save!

user.restaurants.create(name: "#{Faker::Name.name}", address: "#{Faker::Address.street_name}", tel: "02-7777-2282", branch: "#{Faker::Address.community}")