require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'Association' do
    it { should belong_to(:restaurant)}
  end

  describe 'Validations' do
    let(:restaurant) { create(:restaurant) }
    context 'Presence' do
      it {should validate_presence_of(:name)}
      it {should validate_presence_of(:phone)}
      it {should validate_presence_of(:gender)}
      it {should validate_presence_of(:state)}
      it {should validate_presence_of(:arrival_time)}
      it {should validate_presence_of(:adult_quantity)}
      it {should validate_presence_of(:child_quantity)}
      it {should validate_numericality_of(:adult_quantity).is_greater_than(0)}
      it {should validate_numericality_of(:child_quantity).is_greater_than(-1)}
    end
    context 'Numericality' do
      it {should validate_numericality_of(:adult_quantity).is_greater_than(0)}
      it {should validate_numericality_of(:child_quantity).is_greater_than(-1)}
    end

    context 'Format' do
      it { should allow_value( Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)).for(:arrival_time) }
    end
  end
end
