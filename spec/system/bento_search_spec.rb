require "system_helper"

RSpec.describe "Bento Search" do
  context "when no query is provided" do
    it "shows the bento search form" do
      visit bento_search_index_path
      expect(page).to have_css(".navbar-search")
    end
  end

  context "when search engine request returns an error" do
    before do
      WebMock.stub_request(:get, /test.host\/catalog.json/)
        .with(
          headers: {
            "Accept" => "application/json"
          }
        )
        .to_return(status: 500, body: "", headers: {"Content-Type" => "application/json"})
    end

    it "displays an error message" do
      visit bento_search_index_path(q: "hydrogen")
      expect(page).to have_css("#catalogue")
      expect(page).to have_content("Sorry! An error occurred and results could not be retrieved.")
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

    it "displays an error message" do
      visit bento_search_index_path(q: "hydrogen")
      expect(page).to have_css("#catalogue")
      expect(page).to have_content("Sorry! An error occurred and results could not be retrieved.")
    end
  end

  context "when EDS search returns an error" do
    before do
      WebMock.stub_request(:post, /eds-api.ebscohost.com\/edsapi\/rest\/Search/)
        .with(
          headers: {
            "Accept" => "application/json",
            "X-Authenticationtoken" => "AGPGzYCzk-NO9_ueZr4gxTl-MP2cQWQ1zUR7IkN1c3RvbWVySWQiOiJzODQyMzUxNiIsIkdyb3VwSWQiOiJtYWluIn0",
            "X-Sessiontoken" => "17e7115f-5c8a-495b-98bc-61f5c330d71a.+D51EefNZ/p2kEbaEIqJRQ=="
          }
        )
        .to_raise(StandardError)
    end

    it "displays an error message" do
      visit bento_single_search_path(q: "hydrogen", engine: "ebsco_eds_keyword")
      expect(page).to have_content("Sorry! An error occurred and results could not be retrieved.")
    end
  end

  def cat_response
    IO.read("spec/files/bento_search/cat_search.json")
  end
end
