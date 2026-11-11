# frozen_string_literal: true

require "rails_helper"

RSpec.describe CitationHelper do
  %i[export_as_apa_citation_txt export_as_mla_citation_txt export_as_harvard_citation_txt].each do |method|
    it "preserves safe emphasis and persistent URLs in bulk #{method} HTML" do
      document = SolrDocument.new(id: "123", marc_ss: "<record/>")
      allow(document).to receive(method).and_return('Author. <i>Fish &amp; chips</i>. <strong>Edition</strong> <script>alert(1)</script><a href="javascript:alert(1)" onclick="alert(1)">link</a>')

      html = helper.citation_copy_all_html(method, [document])
      fragment = Nokogiri::HTML.fragment(html)
      expect(fragment.at_css("i").text).to eq("Fish & chips")
      expect(fragment.at_css("strong").text).to eq("Edition")
      expect(fragment.text).to include("Catalogue persistent identifier: https://nla.gov.au/nla.cat-vn123")
      expect(html).not_to include("<script", "javascript:", "onclick")
    end
  end

  it "separates each citation into its own paragraph" do
    documents = %w[1 2].map { |id| SolrDocument.new(id: id, marc_ss: "<record/>") }
    documents.each { |document| allow(document).to receive(:export_as_apa_citation_txt).and_return("<em>Title</em>") }
    fragment = Nokogiri::HTML.fragment(helper.citation_copy_all_html(:export_as_apa_citation_txt, documents))
    expect(fragment.css("p").length).to eq(2)
    expect(fragment.css("p em").length).to eq(2)
  end

  it "copies plain text rather than HTML markup or entities" do
    document = SolrDocument.new(id: "123", marc_ss: "<record/>")
    allow(document).to receive(:export_as_apa_citation_txt).and_return("<i>Fish &amp; chips</i>")

    expect(helper.citation_copy_all_text(:export_as_apa_citation_txt, [document])).to eq(
      "Fish & chips\nCatalogue persistent identifier: https://nla.gov.au/nla.cat-vn123"
    )
  end
end
