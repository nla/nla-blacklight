# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchController do
  it_behaves_like "BentoQueryConcern", described_class

  describe "GET index" do
    context "when no query is provided" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns @results to a nil object" do
        get :index
        expect(assigns(:results)).to be_nil
      end

      it "assigns @total_results to 0" do
        get :index
        expect(assigns(:total_results)).to eq 0
      end
    end

    context "when a query is provided" do
      it "returns http success" do
        get :index, params: {q: "hydrogen"}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
