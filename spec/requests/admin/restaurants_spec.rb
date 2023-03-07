require 'rails_helper'

RSpec.describe "Admin::Restaurants", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/restaurants/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/restaurants/show"
      expect(response).to have_http_status(:success)
    end
  end

end
