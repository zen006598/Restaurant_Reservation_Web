require 'rails_helper'

feature "Setting the time button", type: :feature do
  context 'Show the time button' do
    let!(:restaurant) { create(:restaurant) }
    let!(:time_module) {create(:time_module, day_of_week_list: (0..6).to_a, restaurant: restaurant)}
    let!(:business_time) {create(:business_time, time_module: time_module)}
    let!(:seat) {create_list(:seat, 10, restaurant: restaurant)}
    scenario 'success', js: true do
      available_reservable_time = restaurant.time_modules.first.available_reservable_time
      available_reservable_time.map!{|i| Time.at(i).strftime('%R')}
      visit restaurant_path(restaurant)
      page_display_time = page.all('label.time-button').map{|el| el.text}
      expect(page_display_time).to eq(available_reservable_time)
    end

    scenario 'switch date', js: true do
      restaurant.time_modules.first.update(day_of_week_list: (0..3).to_a)
      time002 = restaurant.time_modules.create(title: 'time002', day_of_week_list: (4..6).to_a)
      time002.business_times.create(start: '09:00'.in_time_zone, _end: '20:00'.in_time_zone)

      available_reservable_time = time002.available_reservable_time.map{|i| Time.at(i).strftime('%R')}
      selectable_time = restaurant.enable_dates.select{|date| (4..6).to_a.include?(date.wday)}.map{|date| date.strftime('%B %d, %Y')}.sample

      visit restaurant_path(restaurant)
      page.find('.flatpickr-input').click
      sleep 1
      page.find(".flatpickr-day[aria-label=\"#{selectable_time}\"]").click
      sleep 1
      page_display_time = page.all('label.time-button').map{|el| el.text}
      expect(page_display_time).to eq(available_reservable_time)
    end
  end 
end
