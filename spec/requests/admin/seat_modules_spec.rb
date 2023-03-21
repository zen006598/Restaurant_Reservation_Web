require 'rails_helper'

RSpec.describe "Admin::SeatModules", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/seat_modules/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/seat_modules/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
