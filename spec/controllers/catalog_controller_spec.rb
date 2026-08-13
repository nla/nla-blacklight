# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogController do
  it "includes BentoSessionResetConcern" do
    expect(described_class.ancestors).to include(BentoSessionResetConcern)
  end

  describe "POST #track" do
    it "persists the search context used by record page pagination" do
      allow(controller).to receive(:search_session).and_return({})

      post :track, params: {
        id: "1068705",
        counter: "1",
        document_id: "1068705",
        search_id: "123",
        per_page: "10"
      }

      expect(session[:search]).to include(
        "counter" => "1",
        "document_id" => "1068705",
        "id" => "123",
        "per_page" => "10"
      )
      expect(response).to redirect_to("/catalog/1068705")
    end
  end
end
