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
      title_tsim: ["The main title / A. Writer"],
      uniform_title_ssim: ["Uniform title"],
      subject_ssim: ["One subject", "Two subjects"],
      life_dates_tsim: ["1900", "2000"]
    )
  end

  before do
    stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://copyright.test/%s"))
    stub_request(:get, /copyright\.test/).to_return(status: 200, body: "<response/>")
  end

  def parsed
    CSV.parse(csv)
  end

  it "renders the title and public show fields, plus the persistent identifier last" do
    header = parsed.first
    expect(header.first).to eq("Title")
    expect(header.second).to eq("Bib ID")
    expect(header).to include("Subject")
    expect(header).to include("Life Dates")
    expect(header.last).to eq("Catalogue persistent identifier")
    expect(header).not_to include("Rights information")
  end

  it "includes the main title displayed above the record metadata" do
    expect(parsed.last.first).to eq("The main title / A. Writer")
  end

  it "uses the configured main title field" do
    custom_document = SolrDocument.new(id: "1", heading_ssim: ["Configured title"])
    rows = CSV.parse(described_class.new([custom_document], [], title_field: "heading_ssim").render)
    expect(rows.last.first).to eq("Configured title")
  end

  it "neutralizes spreadsheet formulas in the main title" do
    formula_document = SolrDocument.new(id: "1", title_tsim: ["=1+1"])
    rows = CSV.parse(described_class.new([formula_document], []).render)
    expect(rows.last.first).to eq("'=1+1")
  end

  it "does not retrieve staff-only information" do
    allow(document).to receive(:rights_information).and_raise("Staff-only data must not be accessed")
    expect { csv }.not_to raise_error
  end

  context "with public copyright information" do
    before do
      stub_request(:get, /copyright\.test/).to_return(status: 200, body: File.read("spec/files/copyright/service_response.xml"))
    end

    it "exports the same copyright message and determination details as the record page" do
      text = parsed.last[parsed.first.index("Copyright")]
      expect(text).to include("In Copyright", "You may copy under some circumstances")
      expect(text).to include("Until 2071", "Literary Dramatic Musical", "2001", "Published")
      expect(text).not_to include("<p>", "contextMsg", "1.1")
    end
  end

  context "when the copyright service returns no information" do
    it "keeps the copyright cell empty without losing the other metadata" do
      expect(parsed.last[parsed.first.index("Copyright")]).to eq("")
      expect(parsed.last.first).to eq("The main title / A. Writer")
    end
  end

  context "when the copyright service is unavailable" do
    before { stub_request(:get, /copyright\.test/).to_raise(Faraday::ConnectionFailed) }

    it "still exports the title and MARC metadata" do
      expect(parsed.last.first).to eq("The main title / A. Writer")
      expect(parsed.last[parsed.first.index("Subject")]).to eq("One subject; Two subjects")
      expect(parsed.last[parsed.first.index("Copyright")]).to eq("")
    end
  end

  it "renders one row per document" do
    expect(parsed.length).to eq(2)
  end

  it "neutralizes spreadsheet formulas in exported fields" do
    ["=1+1", "+1+1", "-1+1", "@SUM(1)", "  =1+1", "\t=1+1"].each do |value|
      formula_document = SolrDocument.new(id: "1", uniform_title_ssim: [value])
      rows = CSV.parse(described_class.new([formula_document], fields).render)
      expect(rows.last[rows.first.index("Uniform Title")]).to eq("'#{value}")
    end
  end

  it "does not silently hide unexpected errors in field conditions" do
    field = Blacklight::Configuration::Field.new(key: "test", if: ->(*) { raise ArgumentError, "broken condition" })
    expect { described_class.new(documents, [field]).render }.to raise_error(ArgumentError, "broken condition")
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
