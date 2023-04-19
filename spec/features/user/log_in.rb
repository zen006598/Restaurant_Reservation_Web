require 'rails_helper'

feature "the signin process", type: :feature do
  let!(:user) { create(:user) }

  describe 'Log in', js: true do
    scenario 'success'do
      visit user_session_path
      fill_in('user_email', with: user.email)
      fill_in('user_password', with: 'foobar123')
      click_button('Log in')
      expect(page.find('.alert li').text).to eq('Signed in successfully.')
      expect(current_url).to eq('http://www.example.com/admin/restaurants')
    end

    scenario 'failed' do
      visit user_session_path
      fill_in('user_email', with: user.email)
      fill_in('user_password', with: 'foobar1asdf23')
      click_button('Log in')
      expect(page.find('.alert li').text).to eq('Invalid Email or password.')
    end
  end 
end