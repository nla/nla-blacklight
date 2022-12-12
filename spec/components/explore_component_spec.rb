# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExploreComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485") }

  it "renders a link to Trove" do
    render_inline(described_class.new(document))

    expect(page).to have_xpath("//a[text()='Find in other libraries']")
    expect(page).to have_xpath("//a[contains(@href, '4157485')]")
    expect(page).to have_xpath("//img[contains(@src, 'trove-icon')]")
  end

  it "renders a link to eResources and Research Guides" do
    render_inline(described_class.new(document))

    expect(page.text).to include "Check eResources and Research Guides"
    expect(page).to have_xpath("//a[text()='eResources']")
    expect(page).to have_xpath("//a[text()='Research Guides']")
  end

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

    it "includes the ISBN in the Trove URL" do
      expect(trove_query_value).to include "isbn%3A"
    end

    context "when there are multiple ISBNs" do
      it "separates the ISBNs with 'OR'" do
        expect(trove_query_value).to include "+OR+"
      end
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

    context "when there are multiple callnumbers" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: "4157485", lc_callnum_ssim: ["mc SUDOC Y 1.1/7:107-19", "PIC Drawer 2251 #S2492"]) }

      it "separates the callnumbers with 'OR'" do
        expect(trove_query_value).to include "%22mc+SUDOC+Y+1.1%2F7%3A107-19%22+OR+%22PIC+Drawer+2251+%23S2492%22"
      end
    end
  end

  context "when the online shop search has no results" do
    it "does not render the online shop link" do
      render_inline(described_class.new(document))

      expect(page.text).not_to have_xpath("//a[text()='Buy at our online shop']")
    end
  end

  context "when Google Books search has no results" do
    it "does not render the Google Books preview link" do
      render_inline(described_class.new(document))

      expect(page.text).not_to have_xpath("//a[text()='Preview at Google Books']")
    end
  end

  context "when there is no document ID" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc) }

    it "does not render the component" do
      render_inline(described_class.new(document))

      expect(page.text).to eq ""
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end

  def sample_marc_isbn
    load_marc_from_file 1868021
  end
end
