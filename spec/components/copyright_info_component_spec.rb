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

  it "renders the 'Contact us' link" do
    render_inline(described_class.new(copyright: copyright))

    expect(page.text).to include "Contact us"
  end

  context "when status context message is 1.1" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.1"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end

    it "renders the 'fair dealing' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "fair dealing"
    end
  end

  context "when status context message is 1.2" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.2"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'Out of copyright'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Out of copyright"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end
  end

  context "when status context message is 1.3" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "1.3"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'Copyright uncertain or copyright undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copyright uncertain or copyright undetermined"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end

    it "renders the 'fair dealing' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "fair dealing"
    end
  end

  context "when status context message is 2.1" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.1"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'Out of copyright'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Out of copyright"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "render the Copies Direct link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end
  end

  context "when status context message is 2.2" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "2.2"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright, uncertain or undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright, uncertain or undetermined"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end

    it "renders the 'fair dealing' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "fair dealing"
    end
  end

  context "when status context message is 3" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "3"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "does not render the copyright status" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "strong"
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
    end
  end

  context "when status context message is 4" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "4"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "does not render the copyright status" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "strong"
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
    end
  end

  context "when status context message is 5" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "5"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright, out of copyright, uncertain, undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright, out of copyright, uncertain, undetermined"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
    end
  end

  context "when status context message is 6" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "6"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright, out of copyright, uncertain or undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright, out of copyright, uncertain or undetermined"
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
    end
  end

  context "when status context message is 7" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "7"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright, out of copyright, uncertain or undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright, out of copyright, uncertain or undetermined"
    end

    it "does not render the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).not_to have_css "form[id='copiesdirect_addcart']"
    end

    it "does not render the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).not_to include "Copies Direct"
    end
  end

  context "when status context message is 8" do
    before {
      rights_response = service_response_hash
      rights_response["contextMsg"] = "8"
      allow(copyright).to receive(:info).and_return(rights_response)
    }

    it "renders 'In copyright, out of copyright, uncertain or undetermined'" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "In copyright, out of copyright, uncertain or undetermined"
    end

    it "renders the Copies Direct form" do
      render_inline(described_class.new(copyright: copyright))

      expect(page).to have_css "form[id='copiesdirect_addcart']"
    end

    it "renders the 'Copies Direct' link" do
      render_inline(described_class.new(copyright: copyright))

      expect(page.text).to include "Copies Direct"
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
