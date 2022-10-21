# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyrightInfoComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485) }

  let(:copyright) { object_double(CopyrightInfo.new(document), info: {}) }

  before do
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

    WebMock.stub_request(:get, "https://example.com/copyright/")
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

  it "renders the 'Contact us' link" do
    render_inline(described_class.new(copyright: copyright))

    expect(page.text).to include "Contact us"
    expect(page).to have_xpath("//a[@href='https://example.com/contact-us']")
  end

  context "when there is a copyright status" do
    it "renders the copyright status" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In Copyright"
    end
  end

  context "when there is no copyright status" do
    before do
      rights_response = no_copyright_status_response_hash
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the copyright status" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "In Copyright"
    end
  end

  context "when status context message is 1.1" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.1"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end

    it "renders the 'fair dealing' as text" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "fair dealing"
      expect(page).not_to have_xpath("//a[text()='fair dealing']")
    end
  end

  context "when status context message is 1.2" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.2"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 1.3" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.3"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end

    it "renders the 'fair dealing' as text" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "fair dealing"
      expect(page).not_to have_xpath("//a[text()='fair dealing']")
    end
  end

  context "when status context message is 2.1" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.1"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "render the Copies Direct link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 2.2" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.2"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 3" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "3"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).not_to have_xpath("//a[@href='javascript:;']")
    end

    it "renders a lowercase contact us link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "contact us"
      expect(page).to have_xpath("//a[@href='https://example.com/contact-us']")
    end
  end

  context "when status context message is 4" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "4"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).not_to have_xpath("//a[@href='javascript:;']")
    end

    it "renders a lowercase contact us link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "contact us"
      expect(page).to have_xpath("//a[@href='https://example.com/contact-us']")
    end
  end

  context "when status context message is 5" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "5"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 6" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "6"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).not_to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 7" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "7"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).not_to have_xpath("//a[@href='javascript:;']")
    end
  end

  context "when status context message is 8" do
    before do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "8"
      allow(copyright).to receive(:info).and_return(rights_response)
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='javascript:;']")
    end
  end

  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end

  def service_response
    IO.read("spec/files/copyright/service_response.xml")
  end

  def no_copyright_status_response_hash
    service_response = service_response_hash
    service_response["copyrightStatus"] = nil
    service_response
  end

  def service_response_hash
    Hash.from_xml(service_response.to_s)["response"]["itemList"]["item"]
  end
end
