require "rails_helper"

RSpec.describe "StaticPages" do
  describe "GET /home" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Search our collections")
    end
  end
end
