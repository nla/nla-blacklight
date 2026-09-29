# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nla::Exports::RISExport do
  subject(:ris) { described_class.new([document]).render }

  let(:document) do
    SolrDocument.new(
      id: "8425632",
      format: "Journal",
      title_tsim: ["The title : a subtitle"],
      uniform_title_ssim: ["Uniform title"],
      author_search_tsim: ["Smith, John", "Jones, Mary"],
      date_lower_isi: "2020",
      publisher_tsim: ["Publisher"],
      display_publication_place_ssim: ["Sydney :"],
      summary_tsim: ["A summary of the work."]
    )
  end

  it "renders a record with the RIS type derived from the format" do
    expect(ris).to include("TY - JOURNAL")
  end

  it "renders one AU line per author" do
    expect(ris).to include("AU - Smith, John")
    expect(ris).to include("AU - Jones, Mary")
  end

  it "renders title, uniform title, pubdate, place, publisher and summary" do
    expect(ris).to include("TI - The title : a subtitle")
    expect(ris).to include("T2 - Uniform title")
    expect(ris).to include("PY - 2020")
    expect(ris).to include("CY - Sydney")
    expect(ris).to include("PB - Publisher")
    expect(ris).to include("AB - A summary of the work.")
  end

  it "includes the catalogue persistent identifier URL" do
    expect(ris).to include("UR - https://nla.gov.au/nla.cat-vn8425632")
  end

  it "ends the record with ER" do
    expect(ris).to include("ER - ")
  end

  context "when the format is not a known RIS record type" do
    let(:document) { SolrDocument.new(id: "1", format: "Weird") }

    it "falls back to GEN" do
      expect(ris).to include("TY - GEN")
    end
  end

  context "with multiple documents" do
    subject(:ris) { described_class.new(documents).render }

    let(:documents) do
      [
        document,
        SolrDocument.new(id: "2", title_tsim: ["Another title"])
      ]
    end

    it "renders one record per document" do
      expect(ris.scan("ER - ").count).to eq(2)
    end
  end
end
