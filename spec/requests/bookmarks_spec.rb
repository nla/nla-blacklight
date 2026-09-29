# frozen_string_literal: true

require "rails_helper"
require "csv"
require "json"

RSpec.describe "Bookmarks" do
  let(:user) { create(:user, :patron) }

  before do
    stub_bookmark_documents
    sign_in user
    user.bookmarks.create!(document_id: "1414519", document_type: "SolrDocument")
    user.bookmarks.create!(document_id: "8425632", document_type: "SolrDocument")
  end

  describe "GET /bookmarks/citation" do
    it "offers a copy-all button for each citation style" do
      get citation_bookmarks_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t("citation.copy_all"))
      expect(response.body).to include("data-clipboard-target=\"source\"")
    end

    it "includes the persistent identifier of every bookmark in the copy-all text" do
      get citation_bookmarks_path

      expect(response.body).to include("https://nla.gov.au/nla.cat-vn1414519")
      expect(response.body).to include("https://nla.gov.au/nla.cat-vn8425632")
    end
  end

  describe "GET /bookmarks/export" do
    it "downloads a CSV of all bookmarks" do
      get export_bookmarks_path(format: "csv")

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Disposition"]).to include('filename="bookmarks.csv"')

      rows = CSV.parse(response.body)
      expect(rows.length).to eq(3)
      expect(rows.first.first).to eq("Bib ID")
      expect(rows.first.last).to eq("Catalogue persistent identifier")

      header = rows.first
      bib_ids = rows[1..].pluck(header.index("Bib ID")).sort
      expect(bib_ids).to eq(["1414519", "8425632"])

      persistent_ids = rows[1..].pluck(header.length - 1).sort
      expect(persistent_ids).to eq([
        "https://nla.gov.au/nla.cat-vn1414519",
        "https://nla.gov.au/nla.cat-vn8425632"
      ])
    end

    it "downloads a RIS of all bookmarks" do
      get export_bookmarks_path(format: "ris")

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Type"]).to include("application/x-research-info-systems")
      expect(response.headers["Content-Disposition"]).to include('filename="bookmarks.ris"')

      expect(response.body).to include("TY - BOOK")
      expect(response.body).to include("UR - https://nla.gov.au/nla.cat-vn1414519")
      expect(response.body).to include("UR - https://nla.gov.au/nla.cat-vn8425632")
      expect(response.body.scan("ER - ").count).to eq(2)
    end
  end

  describe "when the user is not logged in" do
    before { sign_out :user }

    it "redirects away from the citation view" do
      get citation_bookmarks_path
      expect(response).to have_http_status(:found)
    end

    it "redirects away from the export" do
      get export_bookmarks_path(format: "csv")
      expect(response).to have_http_status(:found)
    end
  end

  private

  def stub_bookmark_documents
    fixture = JSON.parse(IO.read("spec/files/document_export/search_response.json"))
    doc = fixture["response"]["docs"].first
    second = doc.merge(id: "8425632", title_tsim: ["The hydrogen record / A. Smith"])
    body = {response: {numFound: 2, start: 0, docs: [doc, second]}}.to_json

    [:get, :post].each do |method|
      WebMock.stub_request(method, /solr:8983/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: body, headers: {"Content-Type" => "application/json"})
    end
  end
end
