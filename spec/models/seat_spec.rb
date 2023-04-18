require 'rails_helper'

RSpec.describe Seat, type: :model do
  describe 'Associations' do
    it {should belong_to(:restaurant)}
    it {should belong_to(:seat_module)}
  end

  describe 'Validation' do
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:state)}
    it {should validate_presence_of(:capacity)}
    it {should validate_numericality_of(:capacity).is_greater_than(0)}
  end

  describe 'Enum' do
    it { should define_enum_for(:state).with_values(empty: 0, occupy: 1) }
  end

  describe 'after_save' do
    let!(:restaurant) { create(:restaurant) }
    let!(:seat_module) { create(:seat_module, restaurant: restaurant) }
    let!(:seat) { create(:seat, restaurant: restaurant, seat_module: seat_module) }

    it "sets the maximum capacity in Redis" do
      key = Seat.sha1(seat.restaurant_id)
      redis_maximum_capacity = $redis.hget(key, :maximum_capacity).to_i
      redis_ttl = $redis.ttl(key)
      expect(redis_maximum_capacity).to eq(seat.capacity)
      expect(redis_ttl).to eq(30.days)
    end
  end
end
