require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:restaurant) { create(:restaurant, :skip_validate) }
  let!(:time_module){create(:time_module, day_of_week_list: (0..6).to_a, restaurant: restaurant)}
  let!(:business_time){create(:business_time, time_module: time_module)}
  subject { create(:reservation, restaurant: restaurant) }

  describe 'Association' do
    # it { should belong_to(:restaurant)}
  end

  describe 'Validations' do
    context 'Presence' do
      [:name, :phone, :gender, :state, :adult_quantity, :child_quantity].each do |field|
        it { should validate_presence_of(field) }
      end
      # it {should validate_presence_of(:arrival_time)}
    end

    context 'Numericality' do
      it {should validate_numericality_of(:adult_quantity).is_greater_than(0)}
      it {should validate_numericality_of(:child_quantity).is_greater_than_or_equal_to(0)}
    end

    context 'Format' do
      # it { should allow_value( Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)).for(:arrival_time) }
    end

    context '#verify_arrival_time_in_business_time' do
      let!(:reservation) { create(:reservation, restaurant: restaurant)}
      it 'valided' do
        expect(reservation.valid?).to eq true
      end

      it 'invlided' do
        time = Faker::Time.backward(days: 3)
        reservation.update(arrival_time: time)
        expect(reservation.valid?).to eq false
      end
    end
  end

  describe 'Enum' do
    it { should define_enum_for(:gender).with_values(male: 1, female: 2, other: 3) }
  end
end
