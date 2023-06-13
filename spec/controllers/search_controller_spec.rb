# frozen_string_literal: true

require "rails_helper"
require_relative "../shared_examples/bento_query_concern_spec"

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
    end

    context "when a query is provided" do
      it "returns http success" do
        get :index, params: {q: "hydrogen"}
        expect(response).to have_http_status(:success)
      end
    end

    context "when a search engine request returns an error" do
      before do
        WebMock.stub_request(:get, /test.host\/catalog.json/)
          .with(
            headers: {
              "Accept" => "application/json"
            }
          )
          .to_return(status: 500, body: "", headers: {"Content-Type" => "application/json"})
      end

      it "returns http success but no results" do
        get :index, params: {q: "hydrogen"}
        expect(response).to have_http_status(:success)
      end
    end

    context "when a search engine request times out" do
      before do
        WebMock.stub_request(:get, /test.host\/catalog.json/)
          .with(
            headers: {
              "Accept" => "application/json"
            }
          )
          .to_timeout
      end

      it "returns http success but no results" do
        get :index, params: {q: "hydrogen"}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
