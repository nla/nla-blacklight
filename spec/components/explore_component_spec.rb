# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExploreComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485") }

  it "renders a link to Trove" do
    render_inline(described_class.new(document))

    expect(page).to have_xpath("//a[text()='Find in other libraries at Trove']")
    expect(page).to have_xpath("//a[contains(@href, '4157485')]")
    expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
  end

  it "renders a link to eResources and Research Guides" do
    render_inline(described_class.new(document))

    expect(page.text).to include "Check eResources and Research Guides"
    expect(page).to have_link(href: "https://www.nla.gov.au/eresources", text: "eResources")
    expect(page).to have_link(href: "https://www.nla.gov.au/research-guides", text: "Research Guides")
  end

  context "when the online shop search has no results" do
    it "does not render the online shop link" do
      render_inline(described_class.new(document))

      expect(page.text).not_to have_xpath("//a[text()='Buy at our online shop']")
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

      let(:document) { SolrDocument.new(marc_ss: sample_marc_isbn, id: "1868021") }

      it "includes the ISBNs in the Trove URL" do
        expect(trove_query_value).to include "isbn%3A"
      end

      it "separates the ISBNs with 'OR'" do
        expect(trove_query_value).to include "+OR+"
      end
    end

    context "when there are callnumbers" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", lc_callnum_ssim: ["mc SUDOC Y 1.1/7:107-19"]) }

      it "includes the callnumber in the Trove URL" do
        expect(trove_query_value).to include "%22mc+SUDOC+Y+1.1%2F7%3A107-19%22"
      end
    end

    context "when there are multiple callnumbers" do
      subject(:trove_query_value) do
        described_class.new(document).trove_query
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", lc_callnum_ssim: ["mc SUDOC Y 1.1/7:107-19", "PIC Drawer 2251 #S2492"]) }

      it "separates the callnumbers with 'OR'" do
        expect(trove_query_value).to include "%22mc+SUDOC+Y+1.1%2F7%3A107-19%22+OR+%22PIC+Drawer+2251+%23S2492%22"
      end
    end
  end

  context "when there are no ISBNs or LCCNs" do
    it "does not include the Library Thing script" do
      render_inline(described_class.new(document))

      expect(page.native.to_s).not_to include "www.librarything.com"
      expect(page.native.to_s).not_to include "books.google.com"
    end
  end

  context "when there are ISBNs" do
    subject(:library_thing_script_value) do
      described_class.new(document).library_thing_script
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391") }

    it "includes the ISBNs in the Library Thing script URL" do
      expect(library_thing_script_value).to include "0902907468"
    end
  end

  describe "#library_thing_script" do
    context "when there is no ISBN" do
      subject(:library_thing_script_value) do
        described_class.new(document).library_thing_script
      end

      it "does not include the ISBN in the Library Thing script URL" do
        expect(library_thing_script_value).to eq "https://www.librarything.com/api/json/workinfo.js?ids=&callback=showLibraryThing"
      end
    end

    context "when there are ISBNs" do
      subject(:library_thing_script_value) do
        described_class.new(document).library_thing_script
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391") }

      it "includes the ISBNs in the Library Thing script URL" do
        expect(library_thing_script_value).to include "0902907468"
      end

      it "separates the LCCNs and ISBNs with ','" do
        expect(library_thing_script_value).to include "ids=74190336,0902907468"
      end
    end

    context "when there are LCCNs" do
      subject(:library_thing_script_value) do
        described_class.new(document).library_thing_script
      end

      let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391") }

      it "includes the LCCNs in the Library Thing script URL" do
        expect(library_thing_script_value).to include "74190336"
      end

      it "separates the LCCNs and ISBNs with ','" do
        expect(library_thing_script_value).to include "ids=74190336,0902907468"
      end
    end
  end

  # describe "#google_books_script" do
  #   context "when there is no ISBN" do
  #     subject(:google_books_script_value) do
  #       described_class.new(document).google_books_script
  #     end
  #
  #     it "does not include the ISBN in the Library Thing script URL" do
  #       expect(google_books_script_value).not_to include "https://books.google.com/books?jscmd=viewapi&bibkeys=&callback=showGoogleBooksPreview"
  #     end
  #   end
  # end

  # describe "#google_lccn_list" do
  #   subject(:google_lccn_list_value) do
  #     described_class.new(document).google_lccn_list
  #   end
  #
  #   let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391") }
  #
  #   it "prefixes the LCCN with 'LCCN:'" do
  #     expect(google_lccn_list_value).to include "LCCN:74190336"
  #   end
  # end
  #
  # describe "#google_isbn_list" do
  #   subject(:google_isbn_list_value) do
  #     described_class.new(document).google_isbn_list
  #   end
  #
  #   let(:document) { SolrDocument.new(marc_ss: sample_marc_lccn, id: "213391") }
  #
  #   it "prefixes the LCCN with 'ISBN:'" do
  #     expect(google_isbn_list_value).to include "ISBN:0902907468"
  #   end
  # end

  def sample_marc
    load_marc_from_file 4157458
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
end
