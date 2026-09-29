# frozen_string_literal: true

require "rails_helper"
require "csv"

RSpec.describe Nla::Exports::CsvExport do
  subject(:csv) { described_class.new(documents, fields).render }

  let(:fields) { CatalogController.blacklight_config.show_fields.to_h.values }
  let(:documents) { [document] }
  let(:document) do
    SolrDocument.new(
      id: "8425632",
      format: "Journal",
      uniform_title_ssim: ["Uniform title"],
      subject_ssim: ["One subject", "Two subjects"],
      life_dates_tsim: ["1900", "2000"]
    )
  end

  def parsed
    CSV.parse(csv)
  end

  it "renders a header with one column per show field, plus the persistent identifier last" do
    header = parsed.first
    expect(header.first).to eq("Bib ID")
    expect(header).to include("Subject")
    expect(header).to include("Life Dates")
    expect(header.last).to eq("Catalogue persistent identifier")
  end

  it "renders one row per document" do
    expect(parsed.length).to eq(2)
  end

  it "joins multi-valued fields with '; '" do
    header = parsed.first
    row = parsed.last
    expect(row[header.index("Subject")]).to eq("One subject; Two subjects")
  end

  it "uses the field's separator options when present" do
    header = parsed.first
    row = parsed.last
    expect(row[header.index("Life Dates")]).to eq("1900 2000")
  end

  it "renders single-valued fields as-is" do
    header = parsed.first
    row = parsed.last
    expect(row[header.index("Bib ID")]).to eq("8425632")
    expect(row[header.index("Format")]).to eq("Journal")
    expect(row[header.index("Uniform Title")]).to eq("Uniform title")
  end

  it "ends each row with the catalogue persistent identifier URL" do
    header = parsed.first
    row = parsed.last
    expect(row[header.index("Catalogue persistent identifier")]).to eq("https://nla.gov.au/nla.cat-vn8425632")
  end

  context "when a document has no data for a field" do
    let(:document) { SolrDocument.new(id: "1") }

    it "renders an empty cell but still includes the persistent identifier" do
      header = parsed.first
      row = parsed.last
      expect(row[header.index("Format")]).to eq("")
      expect(row[header.index("Catalogue persistent identifier")]).to eq("https://nla.gov.au/nla.cat-vn1")
    end
  end
end
