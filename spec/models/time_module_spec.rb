require 'rails_helper'

RSpec.describe TimeModule, type: :model do
  describe "Associations" do
    it { should belong_to(:restaurant) }
    it { should have_many(:business_times).dependent(:destroy).inverse_of(:time_module) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }

    let(:restaurant){create(:restaurant)}
    let(:time_module){create(:time_module, restaurant: restaurant)}

    context '#day_of_week_inclusion_validation' do
      it 'valied' do
        restaurant
        time_module.update(day_of_week_list: [1,3,6,0])
        expect(time_module.day_of_week_list).to include(0..6)
      end

      it 'invalied' do
        time_module.update(day_of_week_list: [7,8])
        expect(time_module.errors.messages).to eq({:day_of_week_list=>["is invalid"]})
      end
    end

    context '#repeat_with_off_days' do
      it 'valied' do
        restaurant.update(off_day_of_week: [0,1])
        time_module.update(day_of_week_list: [2])
        expect(time_module.valid?).to eq(true)
      end

      it 'invalied' do
        restaurant.update(off_day_of_week: [1,2])
        time_module.update(day_of_week_list: [1,2])
        expect(time_module.valid?).to eq(false)
      end
    end

    context '#repeat_with_business_day' do
      let!(:restaurant) { create(:restaurant, off_day_of_week: []) }
      let!(:time_module_1) { create(:time_module, restaurant: restaurant, day_of_week_list: [0, 1, 2, 3]) }
      let!(:time_module_2) { build(:time_module, restaurant: restaurant) }
    
      it 'should be valid when there is no overlapping day of week' do
        time_module_2.update(day_of_week_list: [ 4, 5])
        expect(time_module_2.valid?).to eq true
      end
    
      it 'should be invalid when there is overlapping day of week' do
        time_module_2.update(day_of_week_list: [2, 4, 5])
        expect(time_module_2.valid?).to eq false
      end
    end

  end

  describe "Nested attributes" do
    it { should accept_nested_attributes_for(:business_times).allow_destroy(true) }
  end
end
