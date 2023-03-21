require 'rails_helper'

RSpec.describe SeatModule, type: :model do
  describe 'Associations' do
    it {should belong_to(:restaurant)}
    it {should have_many(:seats)}
  end

  describe 'Validation' do
    it {should validate_presence_of(:title)}
  end
end
