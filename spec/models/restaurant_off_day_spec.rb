require 'rails_helper'

RSpec.describe RestaurantOffDay, type: :model do
  describe 'Association' do
    it { should belong_to(:restaurant) }
    it { should belong_to(:off_day) }
  end
end
