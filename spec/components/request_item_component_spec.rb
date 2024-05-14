# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestItemComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", folio_instance_id_ssim: ["93fe53ff-ffcf-5602-a9c1-be246cfadc5e"]) }

  before do
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_CLIENT" => "catalogue-services"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_SECRET" => "254241c8-1e99-4855-a0ae-52b04702c3e5"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_REALM" => "example-realm"))
    stub_const("ENV", ENV.to_hash.merge("CATALOGUE_SERVICES_API_BASE_URL" => "http://catservices.test/catalogue-services"))
  end

  it "renders the holdings" do
    render_inline(described_class.new(document: document))

    expect(page).to have_css("div.holding")
  end

  context "when DISABLE_REQUESTING is `true`" do
    it "does not render the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return("true")

      render_inline(described_class.new(document: document))

      expect(page).not_to have_css("div.holding")
    end
  end

  context "when DISABLE_REQUESTING is `false`" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return("false")

      render_inline(described_class.new(document: document))

      expect(page).to have_css("div.holding")
    end
  end

  context "when DISABLE_REQUESTING is defined without a value" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DISABLE_REQUESTING").and_return("")

      render_inline(described_class.new(document: document))

      expect(page).to have_css("div.holding")
    end
  end

  context "when DISABLE_REQUESTING is not defined" do
    it "renders the request button" do
      render_inline(described_class.new(document: document))

      expect(page).to have_css("div.holding")
    end
  end

  context "when the item is a monograph" do
    before do
      WebMock.stub_request(:get, "http://catservices.test/catalogue-services/folio/instance/93fe53ff-ffcf-5602-a9c1-be246cfadc5e")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: monograph_response, headers: {})
    end

    it "does not display 'Items/Issues Held:'" do
      render_inline(described_class.new(document: document))

      expect(page).not_to have_content("Items/Issues Held:")
    end
  end

  context "when the item is not a monograph" do
    it "does display 'Items/Issues Held:'" do
      render_inline(described_class.new(document: document))

      expect(page).to have_content("Items/Issues Held:")
    end
  end

  context "when there are no holdings for instance" do
    before do
      WebMock.stub_request(:get, "http://catservices.test/catalogue-services/folio/instance/93fe53ff-ffcf-5602-a9c1-be246cfadc5e")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
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
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 500, body: "", headers: {})
    end

    it "does not render the holdings" do
      render_inline(described_class.new(document: document))

      expect(page).not_to have_css("div.holding")
    end
  end

  context "when the item is requestable" do
    let(:item) { {"requestable" => true} }

    it "displays the item's status as 'Available'" do
      render_inline(described_class.new(document: document))

      expect(page).to have_text("Available")
    end
  end

  context "when the item is not requestable" do
    let(:item) { {"requestable" => false} }

    it "displays the item's status as 'Not for loan'" do
      render_inline(described_class.new(document: document))

      expect(page).to have_text("Not for loan")
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end

  def monograph_response
    IO.read("spec/files/catalogue_services/monograph.json")
  end

  def holdings_response
    IO.read("spec/files/catalogue_services/serial.json")
  end
end
