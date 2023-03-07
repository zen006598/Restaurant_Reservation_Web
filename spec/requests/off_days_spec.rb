require 'rails_helper'

RSpec.describe "OffDays", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/off_days/create"
      expect(response).to have_http_status(:success)
    end
  end

end
