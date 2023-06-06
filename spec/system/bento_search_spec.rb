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
      expect(page).to have_content("Sorry! An error occurred and results could not be retrieved.")
    end
  end

  def cat_response
    IO.read("spec/files/bento_search/cat_search.json")
  end
end
