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
    expect(ris).to include("TY  - JOUR\n")
  end

  {"Magazine" => "MGZN", "Manuscript" => "MANSCPT", "Score" => "MUSIC"}.each do |format, type|
    it "uses the standard RIS type for #{format}" do
      output = described_class.new([SolrDocument.new(id: "1", format: format)]).render
      expect(output).to start_with("TY  - #{type}\n")
    end
  end

  it "renders one AU line per author" do
    expect(ris).to include("AU  - Smith, John")
    expect(ris).to include("AU  - Jones, Mary")
  end

  it "renders title, uniform title, pubdate, place, publisher and summary" do
    expect(ris).to include("TI  - The title : a subtitle")
    expect(ris).to include("T2  - Uniform title")
    expect(ris).to include("PY  - 2020")
    expect(ris).to include("CY  - Sydney")
    expect(ris).to include("PB  - Publisher")
    expect(ris).to include("AB  - A summary of the work.")
  end

  it "exports the catalogue persistent identifier as AN, not UR" do
    expect(ris).to include("AN  - https://nla.gov.au/nla.cat-vn8425632\n")
    expect(ris).not_to include("UR  - https://nla.gov.au/nla.cat-vn8425632")
  end

  it "preserves the catalogue identifier when there is no MARC source" do
    expect(ris).to include("AN  - https://nla.gov.au/nla.cat-vn8425632\n")
    expect(ris.lines.grep(/^UR  - /)).to be_empty
  end

  context "with MARC 856 online-resource URLs" do
    let(:document) do
      SolrDocument.new(id: "8425632", marc_ss: <<~XML)
        <record xmlns="http://www.loc.gov/MARC21/slim">
          <datafield tag="856" ind1="4" ind2="1"><subfield code="u">https://example.org/resource</subfield></datafield>
          <datafield tag="856" ind1="4" ind2="1"><subfield code="u">https://example.org/resource</subfield></datafield>
          <datafield tag="856" ind1="4" ind2="1"><subfield code="u">https://example.org/another-resource</subfield></datafield>
        </record>
      XML
    end

    it "keeps resource URLs in UR and the catalogue identifier separately in AN" do
      expect(ris.lines.grep(/^AN  - /)).to eq(["AN  - https://nla.gov.au/nla.cat-vn8425632\n"])
      expect(ris.lines.grep(/^UR  - /)).to eq([
        "UR  - https://example.org/resource\n",
        "UR  - https://example.org/another-resource\n"
      ])
    end
  end

  context "with a MARC record containing no online-resource URLs" do
    let(:document) { SolrDocument.new(id: "8425632", marc_ss: "<record/>") }

    it "exports AN without adding a catalogue UR fallback" do
      expect(ris).to include("AN  - https://nla.gov.au/nla.cat-vn8425632\n")
      expect(ris.lines.grep(/^UR  - /)).to be_empty
    end
  end

  context "with the Duxiu record's 856 40 URL" do
    let(:document) do
      SolrDocument.new(id: "4967852", title_tsim: ["Duxiu [electronic resource] = duxiu.com"], marc_ss: <<~XML)
        <record xmlns="http://www.loc.gov/MARC21/slim">
          <datafield tag="856" ind1="4" ind2="0"><subfield code="x">ISD5:ANL</subfield><subfield code="u">https://www.duxiu.com</subfield><subfield code="z">Available to National Library registered users</subfield></datafield>
        </record>
      XML
    end

    it "includes the URL in UR while preserving the catalogue link in AN" do
      expect(ris.lines.grep(/^UR  - /)).to eq(["UR  - https://www.duxiu.com\n"])
      expect(ris).to include("AN  - https://nla.gov.au/nla.cat-vn4967852\n")
    end
  end

  [["4", "0"], ["4", "1"], ["4", "2"], [" ", " "], ["7", "8"]].each do |ind1, ind2|
    context "with 856 indicators #{ind1.inspect}, #{ind2.inspect}" do
      let(:document) do
        SolrDocument.new(id: "1", marc_ss: <<~XML)
          <record xmlns="http://www.loc.gov/MARC21/slim">
            <datafield tag="856" ind1="#{ind1}" ind2="#{ind2}"><subfield code="u">https://example.org/resource</subfield></datafield>
          </record>
        XML
      end

      it "exports the URL regardless of indicators" do
        expect(ris.lines.grep(/^UR  - /)).to eq(["UR  - https://example.org/resource\n"])
      end
    end
  end

  context "with repeated, blank, and non-856 URL subfields" do
    let(:document) do
      SolrDocument.new(id: "1", marc_ss: <<~XML)
        <record xmlns="http://www.loc.gov/MARC21/slim">
          <datafield tag="856" ind1="4" ind2="0">
            <subfield code="u"> https://example.org/first </subfield>
            <subfield code="u">https://example.org/second</subfield>
            <subfield code="u"> </subfield>
            <subfield code="u"/>
            <subfield code="z">https://example.org/label-only</subfield>
          </datafield>
          <datafield tag="856" ind1="4" ind2="2"><subfield code="u">https://example.org/first</subfield></datafield>
          <datafield tag="540" ind1=" " ind2=" "><subfield code="u">https://example.org/terms-only</subfield></datafield>
        </record>
      XML
    end

    it "exports every distinct nonblank 856 $u, including repeated $u in the same field" do
      expect(ris.lines.grep(/^UR  - /)).to eq([
        "UR  - https://example.org/first\n",
        "UR  - https://example.org/second\n"
      ])
    end
  end

  it "ends the record with ER" do
    expect(ris).to end_with("ER  - \n\n")
  end

  it "keeps embedded newlines from creating spurious RIS tags" do
    multiline_document = SolrDocument.new(id: "1", title_tsim: ["Title\r\nAU  - Not an author"])
    output = described_class.new([multiline_document]).render
    expect(output).to include("TI  - Title AU  - Not an author\n")
    expect(output).not_to include("\nAU  - Not an author")
  end

  context "when the format is not a known RIS record type" do
    let(:document) { SolrDocument.new(id: "1", format: "Weird") }

    it "falls back to GEN" do
      expect(ris).to include("TY  - GEN")
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
      expect(ris.scan("ER  - ").count).to eq(2)
      expect(ris).to include("ER  - \n\nTY  - ")
      expect(ris.lines.grep(/^AN  - /)).to eq([
        "AN  - https://nla.gov.au/nla.cat-vn8425632\n",
        "AN  - https://nla.gov.au/nla.cat-vn2\n"
      ])
    end
  end
end
