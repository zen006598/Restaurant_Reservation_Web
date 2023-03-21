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
  end

  describe 'Enum' do
    it { should define_enum_for(:state).with_values(empty: 0, occupy: 1) }
  end
end
