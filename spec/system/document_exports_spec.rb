require "system_helper"

RSpec.describe "Document exports" do
  let(:document) { SolrDocument.new(id: 123, marc_ss: marc_xml) }
  let(:copyright) { copyright_response_hash }
  let(:catalogue_services) { object_double(CatalogueServicesClient.new) }
  let(:request_item_component) { object_double(RequestItemComponent.new(document: document)) }

  before do
    driven_by(:rack_test)

    WebMock.stub_request(:get, "https://example.com/copyright/")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: copyright_response, headers: {})
    WebMock.stub_request(:get, /solr:8983/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: solr_response, headers: {})
    WebMock.stub_request(:get, "http://catservices.test/catalogue-services/folio/instance/6bf69425-293d-5e3f-a050-16124aca9a4e")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjExYzkwMGMyMzk5MGY1YTUxNzdkNzMyYjE2M2UyZDdlIn0.eyJleHAiOjE2ODQxMzEwNzEsImlhdCI6MTY4NDEzMDc3MSwianRpIjoiMTYzYzJlZmItOTcyZS00Y2NjLWI2ZGUtMDNlY2U4NjQ1YzFmIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLnRlc3QvYXV0aC9yZWFsbXMvZXhhbXBsZS1yZWFsbSIsInN1YiI6ImJiMWIxNTg3LTRhOGItNDQ2NC1iNTJiLWJhZjVlYjdmNjhjMiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNhdGFsb2d1ZS1zZXJ2aWNlcyIsInJlc291cmNlX2FjY2VzcyI6eyJjYXRhbG9ndWUtc2VydmljZXMiOnsicm9sZXMiOlsidW1hX3Byb3RlY3Rpb24iXX19LCJzY29wZSI6ImNhdHNlcnZpY2UgcHJvZmlsZSByb2xlcyBlbWFpbCIsImNsaWVudEhvc3QiOiIxOTIuMTAyLjIzOS4xOTciLCJjbGllbnRJZCI6ImNhdGFsb2d1ZS1zZXJ2aWNlcyIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6IkpvaG4gU21pdGgiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzZXJ2aWNlLWFjY291bnQtY2F0YWxvZ3VlLXNlcnZpY2VzIiwiZ2l2ZW5fbmFtZSI6IkpvaG4iLCJjbGllbnRBZGRyZXNzIjoiMTkyLjEwMi4yMzkuMTk3IiwiZmFtaWx5X25hbWUiOiJTbWl0aCJ9.51SNyl8yPCLvukz4yp0tgI_JPUOvVVsDm1_WjWyds1t9Sbmf5yjLc9tiyFfJUnIcNc1YtWAFzPsRrum8HC8Bmw"
        }
      )
      .to_return(status: 200, body: holdings_response, headers: {})
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))
  end

  it "does not show the 'Export to Refworks' link" do
    visit solr_document_path(id: 1414519)

    expect(page).to have_css("body")
    expect(page).to have_no_text("Export to Refworks")
  end

  it "does not show 'Email' link" do
    visit solr_document_path(id: 1414519)

    expect(page).to have_css("body")
    expect(page).to have_no_text("Email")
  end

  it "does not show the 'SMS This' link" do
    visit solr_document_path(id: 1414519)

    expect(page).to have_css("body")
    expect(page).to have_no_text("SMS This")
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

  def holdings_response
    IO.read("spec/files/catalogue_services/1414519.json")
  end
end
