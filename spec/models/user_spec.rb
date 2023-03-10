require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Association' do
    let(:user) { create(:user)}

    it { should have_many(:restaurants).through(:user_restaurants) }
    it { should have_many(:subordinates).class_name('User')}
    it { should belong_to(:owner).class_name('User').optional}
  end

  describe 'Validation' do
    let(:user) {create(:user)}

    context 'Presence' do
      it {should validate_presence_of(:email)}
      it {should validate_presence_of(:password)}
      it {should validate_presence_of(:role)}
    end

    context 'Uniqueness' do
      it 'Email uniqueness' do
        expect(user).to validate_uniqueness_of(:email).ignoring_case_sensitivity
      end
    end

    context 'Enum' do
      it { should define_enum_for(:role).with_values([:owner, :manager, :staff]) }
    end
  end

  describe 'Instance methods' do
    let(:user) { create(:user) }
    let(:manager) { create(:user, :manager)}
    let(:staff) { create(:user, :staff)}

    it '#owner?' do
      expect(user.owner?).to eq true
    end

    it '#manager?' do
      expect(manager.manager?).to eq true
    end

    it '#staff?' do
      expect(staff.staff?).to eq true
    end
  end
end
