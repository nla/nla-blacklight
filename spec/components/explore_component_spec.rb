# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExploreComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", format: "Map") }

  context "when there is no isbn or issn" do
    it "renders a link to Trove" do
      render_inline(described_class.new(document))

      expect(page).to have_link(text: "Find in other libraries at Trove")
      expect(page).to have_xpath("//a[contains(@href, '4157485')]")
      expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
    end
  end

  context "when there is isbn or issn" do
    let(:document) do
      SolrDocument.new(marc_ss: sample_marc_newspaper, id: "2837256", format: "Newspaper", call_number_tsim: ["NX 276"], isbn_tsim: %w[1839-8138 18398138], issn_display_ssim: ["1839-8138"])
    end

    it "renders a link to Trove" do
      render_inline(described_class.new(document))

      expect(page).to have_link(text: "Find in other libraries at Trove")
      expect(page).to have_xpath("//a[contains(@href, 'isbn%3A18398138%20OR%20issn%3A18398138')]")
      expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
    end
  end

  context "when there is only isbn" do
    let(:document) do
      SolrDocument.new(marc_ss: sample_marc_newspaper, id: "2837256", format: "Newspaper", call_number_tsim: ["NX 276"], isbn_tsim: %w[1839-8138 18398138])
    end

    it "renders a link to Trove" do
      render_inline(described_class.new(document))

      expect(page).to have_link(text: "Find in other libraries at Trove")
      expect(page).to have_xpath("//a[contains(@href, 'isbn%3A18398138')]")
      expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
    end
  end

  context "when there is only issn" do
    let(:document) do
      SolrDocument.new(marc_ss: sample_marc_newspaper, id: "2837256", format: "Newspaper", call_number_tsim: ["NX 276"], issn_display_ssim: ["1839-8138"])
    end

    it "renders a link to Trove" do
      render_inline(described_class.new(document))

      expect(page).to have_link(text: "Find in other libraries at Trove")
      expect(page).to have_xpath("//a[contains(@href, 'issn%3A18398138')]")
      expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
    end
  end

  context "when the online shop search has no results" do
    it "does not render the online shop link" do
      render_inline(described_class.new(document))

      expect(page.text).to have_no_link(text: I18n.t("explore.nla_shop"))
    end
  end

  context "when the online shop search has results" do
    before do
      response = IO.read("spec/files/nla_shop/response.json")

      WebMock.stub_request(:get, /https:\/\/bookshop.nla.gov.au\/api\/jsonDetails.do\?isbn13=9781922507372,9781922507377/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: response, headers: {})
    end

    let(:document) { SolrDocument.new(marc_ss: bookshop_marc, id: "8680859", format: ["Book"], isbn_tsim: %w[9781922507372 1922507377]) }

    it "renders the online shop link" do
      render_inline(described_class.new(document))

      expect(page).to have_no_link(I18n.t("explore.nla_shop"))
    end
  end

  context "when there is no document ID" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc) }

    it "does not render the component" do
      render_inline(described_class.new(document))

      expect(page.text).to eq ""
    end
  end

  describe "#trove_query" do
    context "when there is no ISBN" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      it "does not include the ISBN in the Trove URL" do
        expect(trove_query_value).not_to include "isbn:"
      end
    end

    context "when there are ISBNs" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc_isbn, id: "1868021", isbn_tsim: %w[0855507322 0855507403]) }

      it "includes the ISBNs in the Trove URL" do
        expect(trove_query_value).to include "isbn%3A"
      end

      it "separates the ISBNs with 'OR'" do
        expect(trove_query_value).to include "%20OR%20"
      end
    end

    context "when there are callnumbers" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", call_number_tsim: ["mc SUDOC Y 1.1/7:107-19"]) }

      it "includes the callnumber in the Trove URL" do
        expect(trove_query_value).to include "%22mc%20SUDOC%20Y%201.1%2F7%3A107-19%22"
      end
    end

    context "when there are multiple callnumbers" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", call_number_tsim: ["mc SUDOC Y 1.1/7:107-19", "PIC Drawer 2251 #S2492"]) }

      it "separates the callnumbers with 'OR'" do
        expect(trove_query_value).to include "%22mc%20SUDOC%20Y%201.1%2F7%3A107-19%22%20OR%20%22PIC%20Drawer%202251%20%23S2492%22"
      end
    end
  end

  describe "#google_books_script" do
    context "when there is no ISBN" do
      subject(:google_books_script_value) do
        described_class.new(document).google_books_script
      end

      it "does not include the ISBN in the Google Books URL" do
        expect(google_books_script_value).not_to include "ISBN:"
      end
    end

    context "when there are ISBNs" do
      subject(:google_books_script_value) do
        described_class.new(document).google_books_script
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391", isbn_tsim: ["0902907468"]) }

      it "prefixes the ISBN list with 'ISBN:'" do
        expect(google_books_script_value).to include "ISBN:0902907468"
      end
    end

    context "when there is no LCCN" do
      subject(:google_books_script_value) do
        described_class.new(document).google_books_script
      end

      it "does not include the ISBN in the Google Books URL" do
        expect(google_books_script_value).not_to include "LCCN:"
      end
    end

    context "when there are LCCNs" do
      subject(:google_books_script_value) do
        described_class.new(document).google_books_script
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391", isbn_tsim: ["0902907468"], lccn_ssim: ["74190336"]) }

      it "prefixes the LCCN list with 'LCCN:'" do
        expect(google_books_script_value).to include "LCCN:74190336"
      end
    end
  end

  describe "#render_map_search?" do
    context "when the format is Map" do
      it "returns true" do
        expect(described_class.new(document).render_map_search?).to be true
      end
    end

    context "when there is no format" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485") }

      it "returns false" do
        expect(described_class.new(document).render_map_search?).to be false
      end
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end

  def sample_marc_newspaper
    load_marc_from_file 2837256
  end

  def sample_marc_isbn
    load_marc_from_file 1868021
  end

  def sample_marc_lccn
    load_marc_from_file 213391
  end

  def no_external_resources
    load_marc_from_file 1336868
  end

  def bookshop_marc
    load_marc_from_file 8680859
  end
end
