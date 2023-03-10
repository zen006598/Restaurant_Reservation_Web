require 'rails_helper'

RSpec.describe OffDay, type: :model do
  describe 'Association' do
    it { should have_many(:restaurants).through(:restaurant_off_days) }
  end

  describe 'Validation' do
    let(:off_day) { create :off_day}
    context 'Presence' do
      it { should validate_presence_of(:day)}
    end

    context 'Uniqueness' do
      it 'day uniqueness' do
        expect(off_day).to validate_uniqueness_of(:day).ignoring_case_sensitivity
      end
    end

    context 'Format' do
      it { should allow_value( Faker::Date.forward(days: 10)).for(:day) }
      it { should_not allow_value(10.days.ago).for(:day) }
    end
  end
end
