# frozen_string_literal: true

require "rails_helper"
require "csv"
require "json"

RSpec.describe "Bookmarks" do
  let(:user) { create(:user, :patron) }

  before do
    stub_bookmark_documents
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://copyright.test/%s"))
    stub_request(:get, /copyright\.test/).to_return(status: 200, body: File.read("spec/files/copyright/service_response.xml"))
    sign_in user
    user.bookmarks.create!(document_id: "1414519", document_type: "SolrDocument")
    user.bookmarks.create!(document_id: "8425632", document_type: "SolrDocument")
  end

  describe "GET /bookmarks/cite_all" do
    %w[apa mla harvard].each do |style|
      it "displays a consolidated #{style} bibliography with persistent identifiers" do
        get cite_all_bookmarks_path(style: style), headers: {"X-Requested-With" => "XMLHttpRequest"}

        expect(response).to have_http_status(:success)
        source = response.parsed_body.at_css('[data-clipboard-target="source"]')
        expect(source.text).to include("https://nla.gov.au/nla.cat-vn1414519")
        expect(source.text).to include("https://nla.gov.au/nla.cat-vn8425632")
        expect(response.body).to include(I18n.t("citation.copy_all"))
        expect(response.body).not_to include("Wikipedia")
      end
    end

    it "allows copying a single bookmark" do
      user.bookmarks.where(document_id: "8425632").delete_all
      stub_bookmark_documents(single: true)
      get cite_all_bookmarks_path(style: "apa")

      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t("citation.copy_all"))
      expect(response.body).not_to include("https://nla.gov.au/nla.cat-vn8425632")
    end

    it "rejects unsupported styles" do
      get cite_all_bookmarks_path(style: "wikipedia")
      expect(response).to have_http_status(:bad_request)
    end

    it "shows an empty-state message without querying Solr when there are no bookmarks" do
      user.bookmarks.delete_all
      get cite_all_bookmarks_path(style: "apa")

      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t("blacklight.bookmarks.no_bookmarks"))
      expect(response.body).not_to include('data-clipboard-target="source"')
      expect(WebMock).not_to have_requested(:get, /solr:8983/)
      expect(WebMock).not_to have_requested(:post, /solr:8983/)
    end
  end

  describe "GET /bookmarks" do
    it "offers the three Cite all styles and export formats" do
      get bookmarks_path

      expect(response).to have_http_status(:success)
      %w[apa mla harvard].each do |style|
        expect(response.parsed_body.at_css("a[href='#{cite_all_bookmarks_path(style: style)}']")).to be_present
      end
      %w[csv ris].each do |format|
        expect(response.parsed_body.at_css("a[href='#{export_bookmarks_path(format: format)}']")).to be_present
      end
      expect(response.parsed_body.at_css("a[href='#{citation_bookmarks_path}']")).to be_nil
    end
  end

  describe "GET /bookmarks/export" do
    it "downloads a CSV of all bookmarks" do
      get export_bookmarks_path(format: "csv")

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Disposition"]).to include('filename="bookmarks.csv"')

      rows = CSV.parse(response.body)
      expect(rows.length).to eq(3)
      expect(rows.first.first).to eq("Title")
      expect(rows[1..].pluck(0)).to include("The hydrogen record / A. Smith")
      expect(rows.first.last).to eq("Catalogue persistent identifier")

      header = rows.first
      expect(rows[1..].pluck(header.index("Copyright"))).to all(include("In Copyright", "You may copy under some circumstances", "Until 2071"))
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

      expect(response.body).to include("TY  - BOOK")
      expect(response.body).to include("AN  - https://nla.gov.au/nla.cat-vn1414519")
      expect(response.body).to include("AN  - https://nla.gov.au/nla.cat-vn8425632")
      expect(response.body).not_to include("UR  - https://nla.gov.au/nla.cat-vn")
      expect(response.body.scan("ER  - ").count).to eq(2)
    end
  end

  describe "with bookmarks spanning multiple pages" do
    let(:bookmark_ids) { ["1414519", "8425632"] + (1..20).map { |number| "extra-#{number}" } }

    before do
      bookmark_ids.drop(2).each do |id|
        user.bookmarks.create!(document_id: id, document_type: "SolrDocument")
      end
      stub_bookmark_documents(ids: bookmark_ids)
    end

    it "requests every bookmark when generating citations" do
      get cite_all_bookmarks_path(style: "apa", per_page: 10)

      expect(response.body).to include("https://nla.gov.au/nla.cat-vnextra-20")
      expect(WebMock).to have_requested(:any, /solr:8983/).with { |request|
        Rack::Utils.parse_nested_query([request.uri.query, request.body].compact.join("&"))["rows"] == "22"
      }
    end

    it "exports every bookmark rather than just the current page" do
      get export_bookmarks_path(format: "csv", per_page: 10)

      expect(CSV.parse(response.body).length).to eq(23)
      expect(WebMock).to have_requested(:any, /solr:8983/).with { |request|
        Rack::Utils.parse_nested_query([request.uri.query, request.body].compact.join("&"))["rows"] == "22"
      }
    end
  end

  describe "when the user is not logged in" do
    before { sign_out :user }

    it "redirects away from the citation view" do
      get cite_all_bookmarks_path(style: "apa")
      expect(response).to have_http_status(:found)
    end

    it "redirects away from the export" do
      get export_bookmarks_path(format: "csv")
      expect(response).to have_http_status(:found)
    end
  end

  private

  def stub_bookmark_documents(single: false, ids: nil)
    fixture = JSON.parse(IO.read("spec/files/document_export/search_response.json"))
    doc = fixture["response"]["docs"].first
    second = doc.merge(id: "8425632", title_tsim: ["The hydrogen record / A. Smith"])
    documents = single ? [doc] : [doc, second]
    documents = ids.map { |id| doc.merge("id" => id) } if ids
    body = {response: {numFound: documents.length, start: 0, docs: documents}}.to_json

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
