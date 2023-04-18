require 'rails_helper'

feature "the signin process", type: :feature do
  let!(:user) { create(:user) }

  before(:each) do
    login_as(user, scope: :user)
    visit new_admin_restaurant_path(user)
  end

  describe 'Create restaurant' do
    scenario 'success'do
      name = Faker::Name.name
      fill_in('restaurant_name', with: name)
      fill_in('restaurant_address', with: Faker::Address.street_name)
      fill_in('restaurant_tel', with: "02-5577-1001")
      fill_in('restaurant_dining_time', with: 60)
      fill_in('restaurant_interval_time', with: 15)
      fill_in('restaurant_period_of_reservation', with: 30)
      click_button 'Create Restaurant'
      expect(current_url).to eq("http://www.example.com/admin/restaurants/1/setting")
      expect(page.find('.alert-notice li').text).to eq("#{name} is successfully created")
    end

    scenario 'failed' do
      name = Faker::Name.name
      fill_in('restaurant_name', with: name)
      fill_in('restaurant_address', with: Faker::Address.street_name)
      fill_in('restaurant_tel', with: "02-5577-1001")
      fill_in('restaurant_dining_time', with: 60)
      fill_in('restaurant_interval_time', with: 15)
      fill_in('restaurant_period_of_reservation', with: 0)
      click_button 'Create Restaurant'

      expect(page.find('.alert').text).to eq('Period of reservation must be greater than 0')
    end
  end 
end