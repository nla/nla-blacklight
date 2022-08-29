# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolrDocument do
  describe "#description" do
    subject do
      document = described_class.new(marc_ss: single_series)
      document.description
    end

    it { is_expected.to eq "Shatin, N. T., Hong Kong : Institute of Chinese Studies, Chinese University of Hong Kong, c1985, x, 197 p. : ill. ; 26 cm." }
  end

  describe "#online_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    describe "when there is an online resource" do
      subject(:access) do
        document.online_access
      end

      it do
        expect(access).to eq [{href: "https://nla.gov.au/nla.obj-600301366", text: "National edeposit"},
          {href: "http://epress.anu.edu.au/AH33_citation.html", text: "http://epress.anu.edu.au/AH33_citation.html"},
          {href: "http://epress.anu.edu.au/titles/aboriginal-history-journal", text: "Publisher site"}]
      end
    end

    describe "when there is an online copy" do
      subject { document.copy_access }

      it { is_expected.to eq [{href: "http://nla.gov.au/nla.arc-139469", text: "Archived at ANL (2012-2016)"}] }
    end

    describe "when there are related resources" do
      subject { document.related_access }

      it { is_expected.to eq [{href: "https://nla.gov.au/nla.obj-600301366-t", text: "Thumbnail"}] }
    end
  end

  describe "#map_search", :vcr do
    describe "when there is a record in Map Search" do
      subject do
        document = described_class.new(marc_ss: map_search, id: 113030, format: "Map")
        document.map_search
      end

      it { is_expected.to eq ["https://georekt-test.nla.gov.au/mapsearch/?type=map&mapClassifications=all&geolocation=all&text=113030"] }
    end

    describe "when there is no record in Map Search" do
      subject do
        document = described_class.new(marc_ss: no_map_search, id: 3647081, format: "Map")
        document.map_search
      end

      it { is_expected.to be_nil }
    end
  end

  describe "#series" do
    describe "when there is a single series" do
      subject do
        document = described_class.new(marc_ss: single_series)
        document.series
      end

      it { is_expected.to eq ["International Symposium on Sino-Japanese Cultural Interchange (1979 : Chinese University of Hong Kong). Papers ; v. 1."] }
    end

    describe "when there are multiple series" do
      subject(:series) do
        document = described_class.new(marc_ss: multiple_series)
        document.series
      end

      it do
        expect(series).to eq ["Australian National Audit Office. Audit report ; 2005-2006, no. 16",
          "Australian National Audit Office. Performance report",
          "Auditor-General audit report ; no. 16, 2005-2006",
          "Performance audit / Australian National Audit Office",
          "Parliamentary paper (Australia. Parliament) ; 2005, no. 434."]
      end
    end
  end

  describe "#notes" do
    describe "when there is a single note" do
      subject do
        document = described_class.new(marc_ss: single_note)
        document.notes
      end

      it { is_expected.to eq({notes: ["Cover title."], more_notes: []}) }
    end

    describe "when there are multiple notes" do
      subject(:notes) do
        document = described_class.new(marc_ss: multiple_notes)
        document.notes
      end

      it do
        expect(notes).to eq({
          notes: ["Originally produced as a motion picture in 1965.",
            "Single-sided single layer; aspect ratio 16:9.",
            "Title from disc label.",
            "Based on the work Nippon military march by Dan Ikuma."],
          more_notes: ["Based on the work Nippon military march by 團伊玖磨."]
        })
      end
    end
  end

  def single_series
    IO.read("spec/files/marc/109692.marcxml")
  end

  def multiple_series
    IO.read("spec/files/marc/8126677.marcxml")
  end

  def single_note
    IO.read("spec/files/marc/1068705.marcxml")
  end

  def multiple_notes
    IO.read("spec/files/marc/8174421.marcxml")
  end

  def online_access
    IO.read("spec/files/marc/4806783.marcxml")
  end

  def map_search
    IO.read("spec/files/marc/113030.marcxml")
  end

  def no_map_search
    IO.read("spec/files/marc/3647081.marcxml")
  end
end
