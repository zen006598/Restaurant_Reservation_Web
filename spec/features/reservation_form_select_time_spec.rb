require 'rails_helper'

describe "the signin process", type: :feature do
  let!(:restaurant) { create(:restaurant, :skip_validate) }
  let!(:time_module){create(:time_module, day_of_week_list: (0..6).to_a, restaurant: restaurant)}
  let!(:business_time){create(:business_time, time_module: time_module)}

  it 'set the time button' do
    p restaurant
    visit restaurant_path(restaurant)
  end
end