require 'rails_helper'

RSpec.describe BusinessTime, type: :model do
  describe 'Association' do
    it { should belong_to(:time_module) }
  end

  describe 'Validation' do
    context 'Uniqueness' do
      it {should validate_presence_of(:start)}
      it {should validate_presence_of(:_end)}
    end

    context 'Format' do
      it { should allow_value( Time.current ).for(:start) }
      it { should allow_value( Time.current + 1.hours).for(:_end) }
      it { should_not allow_value('Fri, 10 Mar 2023').for(:start) }
      it { should_not allow_value('Fri, 10 Mar 2023').for(:_end) }
    end
  end
end
