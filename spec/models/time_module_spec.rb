require 'rails_helper'

RSpec.describe TimeModule, type: :model do
  describe "Associations" do
    it { should belong_to(:restaurant) }
    it { should have_many(:business_times).dependent(:destroy).inverse_of(:time_module) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
  end

  describe "Nested attributes" do
    it { should accept_nested_attributes_for(:business_times).allow_destroy(true) }
  end
end
