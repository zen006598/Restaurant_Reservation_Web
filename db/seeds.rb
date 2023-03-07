user = User.new({ email: ENV['EMAIL'], password: '111111', password_confirmation: '111111', role: 'owner' })
user.skip_confirmation!
user.save!