# frozen_string_literal: true

require "rails_helper"

RSpec.describe CopyrightStatusComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485) }

  let(:copyright) { service_response_hash }

  before do
    WebMock.stub_request(:get, "https://test.nla.gov.au/copyright/")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
        }
      )
      .to_return(status: 200, body: "", headers: {})
  end

  it "renders the 'Contact us' link" do
    render_inline(described_class.new(document, copyright))

    expect(page.text).to include "Contact us"
    expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/contact-us']")
  end

  it "does not render the Copies Direct form" do
    render_inline(described_class.new(document, copyright))

    expect(page).to have_no_css "form[id='copiesdirect_addcart']"
  end

  context "when there is a copyright status" do
    it "renders the copyright status" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "In Copyright"
    end
  end

  context "when there is no copyright status" do
    let(:copyright) { no_copyright_status_response_hash }

    it "renders the copyright status" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).not_to include "In Copyright"
    end
  end

  context "when status context message is 1.1" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.1"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end

    it "renders the 'fair dealing' as text" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "fair dealing"
      expect(page).to have_no_xpath("//a[text()='fair dealing']")
    end
  end

  context "when status context message is 1.2" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.2"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 1.3" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.3"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end

    it "renders the 'fair dealing' as text" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "fair dealing"
      expect(page).to have_no_xpath("//a[text()='fair dealing']")
    end
  end

  context "when status context message is 2.1" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.1"
      rights_response
    end

    it "render the Copies Direct link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 2.2" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.2"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 3" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "3"
      rights_response
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).to have_no_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end

    it "renders a lowercase contact us link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "contact us"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/contact-us']")
    end
  end

  context "when status context message is 4" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "4"
      rights_response
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).to have_no_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end

    it "renders a lowercase contact us link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "contact us"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/contact-us']")
    end
  end

  context "when status context message is 5" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "5"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 6" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "6"
      rights_response
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).to have_no_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 7" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "7"
      rights_response
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).not_to include "Copies Direct"
      expect(page).to have_no_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  context "when status context message is 8" do
    let(:copyright) do
      rights_response = service_response_hash
      rights_response["contextMsg"] = "8"
      rights_response
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(document, copyright))

      expect(page.text).to include "Copies Direct"
      expect(page).to have_xpath("//a[@href='https://test.nla.gov.au/copies-direct/items/import?source=cat&sourcevalue=4157485']")
    end
  end

  def sample_marc
    load_marc_from_file 4157458
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
