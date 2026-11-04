# frozen_string_literal: true

require "rails_helper"

RSpec.describe CitationHelper do
  it "copies plain text rather than HTML markup or entities" do
    document = SolrDocument.new(id: "123", marc_ss: "<record/>")
    allow(document).to receive(:export_as_apa_citation_txt).and_return("<i>Fish &amp; chips</i>")

    expect(helper.citation_copy_all_text(:export_as_apa_citation_txt, [document])).to eq(
      "Fish & chips\nCatalogue persistent identifier: https://nla.gov.au/nla.cat-vn123"
    )
  end
end
