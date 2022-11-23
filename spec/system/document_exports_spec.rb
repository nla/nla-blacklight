require "rails_helper"

RSpec.describe "Document exports" do
  let(:document) { SolrDocument.new(marc_ss: marc_xml) }
  let(:copyright) { object_double(CopyrightStatus.new(document)) }

  before do
    driven_by(:rack_test)

    WebMock.stub_request(:get, "https://example.com/copyright/")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Faraday v2.6.0"
        }
      )
      .to_return(status: 200, body: copyright_response, headers: {})
    WebMock.stub_request(:get, /solr:8983/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Faraday v2.6.0"
        }
      )
      .to_return(status: 200, body: solr_response, headers: {})
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))
  end

  it "does not show the 'Export to Refworks' link" do
    visit solr_document_path(id: 1414519)

    expect(page).not_to have_text("Export to Refworks")
  end

  it "does not show 'Email' link" do
    visit solr_document_path(id: 1414519)

    expect(page).not_to have_text("Email")
  end

  it "does not show the 'SMS This' link" do
    visit solr_document_path(id: 1414519)

    expect(page).not_to have_text("SMS This")
  end

  private

  def solr_response
    IO.read("spec/files/document_export/search_response.json")
  end

  def marc_xml
    load_marc_from_file 1414519
  end

  def copyright_response
    IO.read("spec/files/copyright/service_response.xml")
  end

  def copyright_response_hash
    Hash.from_xml(copyright_response.to_s)["response"]["itemList"]["item"]
  end
end
