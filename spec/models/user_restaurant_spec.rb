require 'rails_helper'

RSpec.describe UserRestaurant, type: :model do
  describe 'Association' do
    it { should belong_to(:user)}
    it { should belong_to(:restaurant)}
  end
end
