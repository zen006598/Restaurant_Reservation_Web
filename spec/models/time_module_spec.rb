require 'rails_helper'

RSpec.describe TimeModule, type: :model do
  describe "Associations" do
    it { should belong_to(:restaurant) }
    it { should have_many(:business_times).dependent(:destroy).inverse_of(:time_module) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }

    let(:restaurant){create(:restaurant, :skip_validate)}
    let(:time_module){create(:time_module, restaurant: restaurant)}

    context '#day_of_week_inclusion_validation' do
      it 'valied' do
        restaurant
        time_module.update(day_of_week_list: [1,3,6,0])
        expect(time_module.day_of_week_list).to include(0..6)
      end

      it 'invalied' do
        time_module.update(day_of_week_list: [7,8])
        expect(time_module.errors.messages).to eq({day_of_week_list: ["is invalid"]})
      end
    end

    context '#repeat_with_business_day' do
      let!(:restaurant) { create(:restaurant, :skip_validate) }
      let!(:time_module_1) { create(:time_module, restaurant: restaurant, day_of_week_list: [0, 1, 2, 3]) }
      let!(:time_module_2) { build(:time_module, restaurant: restaurant) }
    
      it 'valied' do
        time_module_2.update(day_of_week_list: [4, 5])
        expect(time_module_2.valid?).to eq true
      end
    
      it 'invalied' do
        time_module_2.update(day_of_week_list: [2, 4, 5])
        expect(time_module_2.valid?).to eq false
      end
    end
  end

  describe "Nested attributes" do
    it { should accept_nested_attributes_for(:business_times).allow_destroy(true) }
  end

  describe 'instance methods' do
    context "#compact_params" do
      let!(:restaurant){create(:restaurant, :skip_validate)}
      let!(:time_module) { create(:time_module, restaurant: restaurant, day_of_week_list: [nil, 0, 1, 2, 3]) }
      
      it 'valided' do
        expect(time_module.day_of_week_list).to match_array([0, 1, 2, 3]) 
      end

      it 'invalided' do
        expect(time_module.day_of_week_list).not_to match_array([nil, 0, 1, 2, 3]) 
      end
    end
  end

  describe 'scope' do
    let!(:restaurant) { create(:restaurant, :skip_validate) }
    let!(:time_module_1) { create(:time_module, day_of_week_list: [0, 1, 2, 3], restaurant: restaurant) }
    let!(:time_module_2) { create(:time_module, day_of_week_list: [4, 5, 6], restaurant: restaurant) }
    context 'except_time_module' do
      it 'valided' do
        except_time_module_2 = restaurant.time_modules.except_time_module(time_module_2.id).first.day_of_week_list
        except_time_module_1 = restaurant.time_modules.except_time_module(time_module_1.id).first.day_of_week_list
        expect(except_time_module_2).to match_array([0, 1, 2, 3]) 
        expect(except_time_module_1).to match_array([4, 5, 6]) 
      end

      it 'invalided' do
        time_modules = restaurant.time_modules.pluck(:day_of_week_list).flatten
        except_time_module_1 = restaurant.time_modules.except_time_module(time_module_1.id).first.day_of_week_list
        expect(except_time_module_1).not_to match_array(time_modules) 
      end
    end

    context 'in_which_time_module' do
      it 'valided' do
        expect(restaurant.time_modules.in_which_time_module(3).first).to eq(time_module_1) 
        expect(restaurant.time_modules.in_which_time_module(6).first).to eq(time_module_2) 
      end

      it 'invalided' do
        expect(restaurant.time_modules.in_which_time_module(3).first).not_to eq(time_module_2) 
        expect(restaurant.time_modules.in_which_time_module(6).first).not_to eq(time_module_1) 
      end
    end
  end
end
