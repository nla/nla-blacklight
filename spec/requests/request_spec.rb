require 'rails_helper'

RSpec.describe "Requests", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/request/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/request/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/request/show"
      expect(response).to have_http_status(:success)
    end
  end

end
