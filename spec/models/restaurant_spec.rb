require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'Association' do
    it { should have_many(:users).through(:user_restaurants) }
    it { should have_many(:off_days).through(:restaurant_off_days) }
    it { should have_many(:time_modules)}
    it { should have_many(:seats)}
    it { should have_rich_text(:content) }
  end

  describe 'Validations' do
    let(:restaurant) { create(:restaurant) }
    context 'Presence' do
      it {should validate_presence_of(:name)}
      it {should validate_presence_of(:address)}
      it {should validate_presence_of(:tel)}
    end

    context 'Uniqueness' do

      it 'tel uniqueness' do
        expect(restaurant).to validate_uniqueness_of(:tel).ignoring_case_sensitivity
      end
    end

    context 'Format' do
      it { should allow_values("123-456-7890", "1234567890", "0266001234", "0977111222", '02-6600-1234').for(:tel) }
      it { should_not allow_values("123", "123456789012", "123-abc-4567").for(:tel) }
    end

    context '#off_day_of_week_inclusion_validation' do
      it 'valied' do
        restaurant.update(off_day_of_week: [1,3,6,0])
        expect(restaurant.off_day_of_week).to include(0..6)
      end

      it 'invalied' do
        restaurant.update(off_day_of_week: [1, 3, 6, 0, 7, 8, 9])
        expect(restaurant.valid?).to eq false
      end
    end
  end

  describe 'Instance methods' do
    let(:restaurant) { create(:restaurant) }
    it "#off_day_list=" do
      off_day_list = "#{Faker::Date.between(from: Date.today, to: Date.today + 1.years)}"
      expect { restaurant.off_day_list=(off_day_list) }.to change { restaurant.off_days.count }.by(1)
    end
  end

  describe "Constants" do
    it "Has a constant for days of the week" do
      expect(described_class::DAYOFWEEK).to eq({ Monday: 1, Tuesday: 2, Wednesday: 3,
                                                     Thursday: 4, Friday: 5, Saturday: 6,
                                                     Sunday: 0 }.freeze)
    end
  end
end
