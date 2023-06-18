# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestItemComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", folio_instance_id_ssim: ["93fe53ff-ffcf-5602-a9c1-be246cfadc5e"]) }

  before do
    Flipper.enable(:requesting)
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_CLIENT" => "catalogue-services"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_SECRET" => "254241c8-1e99-4855-a0ae-52b04702c3e5"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_REALM" => "example-realm"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_API_BASE_URL" => "http://catservices.test/catalogue-services"))
  end

  it "renders the holdings" do
    render_inline(described_class.new(document: document))

    expect(page).to have_css("div.holding")
  end

  context "when there are no holdings for instance" do
    before do
      WebMock.stub_request(:get, "http://catservices.test/catalogue-services/folio/instance/93fe53ff-ffcf-5602-a9c1-be246cfadc5e")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
          }
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "does not render the holdings" do
      render_inline(described_class.new(document: document))

      expect(page).not_to have_css("div.holding")
    end
  end

  context "when the catalogue service returns an error" do
    before do
      WebMock.stub_request(:get, "http://catservices.test/catalogue-services/folio/instance/93fe53ff-ffcf-5602-a9c1-be246cfadc5e")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "nla-blacklight/#{Rails.configuration.version}"
          }
        )
        .to_return(status: 500, body: "", headers: {})
    end

    it "does not render the holdings" do
      render_inline(described_class.new(document: document))

      expect(page).not_to have_css("div.holding")
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end

  def holdings_response
    IO.read("spec/files/catalogue_services/serial.json")
  end
end
