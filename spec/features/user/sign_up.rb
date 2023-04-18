require 'rails_helper'

feature "the signin process", type: :feature do
  describe 'Sing up' do
    scenario 'success', js: true do
      visit new_user_registration_path
      fill_in('user_email', with: Faker::Internet.email)
      password = Faker::Internet.password
      fill_in('user_password', with: password)
      fill_in('user_password_confirmation', with: password)
      fill_in('user_name', with: Faker::Name.name)
      click_button('Sign up')
      expect(page.find('.alert-notice li').text).to eq('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
    end

    scenario 'failed', js: true do
      visit new_user_registration_path
      fill_in('user_email', with: Faker::Internet.email)
      password = Faker::Internet.password
      fill_in('user_password', with: password)
      fill_in('user_password_confirmation', with: password + '11')
      fill_in('user_name', with: Faker::Name.name)
      click_button('Sign up')
      expect(page.find('#error_explanation li').text).to eq('Password confirmation doesn\'t match Password')
    end
  end
end