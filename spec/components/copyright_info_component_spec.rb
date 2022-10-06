# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyrightInfoComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485) }

  let(:copyright) { object_double(CopyrightInfo.new(document), info: {}) }

  before do
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

    stub_request(:get, "https://example.com/copyright/")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Faraday v1.10.0"
        }
      )
      .to_return(status: 200, body: "", headers: {})

    allow(copyright).to receive(:document).and_return(document)
    allow(copyright).to receive(:info).and_return(service_response_hash)
  end

  it "renders the Copies Direct form" do
    allow(copyright).to receive(:info).and_return(service_response_hash)

    render_inline(described_class.new(copyright: copyright))

    expect(page).to have_css "form[id='copiesdirect_addcart']"
  end

  context "when status context message is 1.1" do
    it "renders 'In copyright'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 1.2 or 2.1" do
    it "renders 'Out of copyright'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 1.3" do
    it "renders 'Copyright uncertain or copyright undetermined'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 2.2" do
    it "renders 'In copyright, uncertain or undetermined'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 3 or 4" do
    it "does not render the copyright status" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 5" do
    it "renders 'In copyright, out of copyright, uncertain, undetermined'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  context "when status context message is 6, 7 or 8" do
    it "renders 'In copyright, out of copyright, uncertain or undetermined'" do
      pending "add some examples to (or delete) #{__FILE__}"
      fail
    end
  end

  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end

  def service_response
    IO.read("spec/files/copyright/service_response.xml")
  end

  def service_response_hash
    Hash.from_xml(service_response.to_s)["response"]["itemList"]["item"]
  end
end
