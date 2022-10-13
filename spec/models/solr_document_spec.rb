# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolrDocument do
  describe "#description" do
    subject(:description_value) do
      document = described_class.new(marc_ss: single_series)
      document.description
    end

    it "retrieves the description from the MARC record" do
      expect(description_value).to eq "Shatin, N. T., Hong Kong : Institute of Chinese Studies, Chinese University of Hong Kong, c1985, x, 197 p. : ill. ; 26 cm."
    end
  end

  describe "#online_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there is an online resource" do
      subject(:online_access_value) do
        document.online_access
      end

      it "generates links to the online resources" do
        expect(online_access_value).to eq [{href: "https://nla.gov.au/nla.obj-600301366", text: "National edeposit"},
          {href: "http://epress.anu.edu.au/AH33_citation.html", text: "http://epress.anu.edu.au/AH33_citation.html"},
          {href: "http://epress.anu.edu.au/titles/aboriginal-history-journal", text: "Publisher site"}]
      end
    end
  end

  describe "#copy_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there is an online copy" do
      subject(:copy_access_value) { document.copy_access }

      it "generates links to the online copy" do
        expect(copy_access_value).to eq [{href: "http://nla.gov.au/nla.arc-139469", text: "Archived at ANL (2012-2016)"}]
      end
    end
  end

  describe "#related_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there are related resources" do
      subject(:related_access_value) { document.related_access }

      it "generates links to the related resources" do
        expect(related_access_value).to eq [{href: "https://nla.gov.au/nla.obj-600301366-t", text: "Thumbnail"}]
      end
    end
  end

  describe "#map_search", :vcr do
    context "when there is a record in Map Search" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: map_search, id: 113030, format: "Map")
        document.map_search
      end

      let(:mock_response) { IO.read("spec/files/map_search/113030.json") }

      it "generates a link to Map Search" do
        stub_request(:get, "https://georekt-test.nla.gov.au/mapsearch/search/search?text=113030&type=map")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: mock_response, headers: {})

        expect(map_search_value).to eq ["https://georekt-test.nla.gov.au/mapsearch/?type=map&mapClassifications=all&geolocation=all&text=113030"]
      end
    end

    context "when there is no record in Map Search" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: no_map_search, id: 3647081, format: "Map")
        document.map_search
      end

      let(:mock_response) { IO.read("spec/files/map_search/3647081.json") }

      it "does not generate a link to Map Search" do
        stub_request(:get, "https://georekt-test.nla.gov.au/mapsearch/search/search?text=3647081&type=map")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: mock_response, headers: {})

        expect(map_search_value).to be_nil
      end
    end

    context "when there is no 'format'" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: no_map_search, id: 3647081, format: nil)
        document.map_search
      end

      it "does not generate a link to Map Search" do
        expect(map_search_value).to be_nil
      end
    end
  end

  describe "#series" do
    context "when there is a single series" do
      subject(:series_value) do
        document = described_class.new(marc_ss: single_series)
        document.series
      end

      it "retrieves the series from the MARC record" do
        expect(series_value).to eq ["International Symposium on Sino-Japanese Cultural Interchange (1979 : Chinese University of Hong Kong). Papers ; v. 1."]
      end
    end

    context "when there are multiple series" do
      subject(:series_value) do
        document = described_class.new(marc_ss: multiple_series)
        document.series
      end

      it "retrieves all the series entries from the MARC record" do
        expect(series_value).to eq ["Australian National Audit Office. Audit report ; 2005-2006, no. 16",
          "Australian National Audit Office. Performance report",
          "Auditor-General audit report ; no. 16, 2005-2006",
          "Performance audit / Australian National Audit Office",
          "Parliamentary paper (Australia. Parliament) ; 2005, no. 434."]
      end
    end
  end

  describe "#notes" do
    context "when there is a single note" do
      subject(:notes_value) do
        document = described_class.new(marc_ss: single_note)
        document.notes
      end

      it "retrieves the note" do
        expect(notes_value).to eq({notes: ["Cover title."], more_notes: []})
      end
    end

    context "when there are multiple notes" do
      subject(:notes_value) do
        document = described_class.new(marc_ss: multiple_notes)
        document.notes
      end

      it "fetches non-880 and 880 notes" do
        expect(notes_value).to eq({
          notes: ["Originally produced as a motion picture in 1965.",
            "Single-sided single layer; aspect ratio 16:9.",
            "Title from disc label.",
            "Based on the work Nippon military march by Dan Ikuma."],
          more_notes: ["Based on the work Nippon military march by 團伊玖磨."]
        })
      end
    end

    context "when there are no notes" do
      subject(:notes_value) do
        document = described_class.new(marc_ss: no_notes)
        document.notes
      end

      it "will return nil" do
        expect(notes_value).to be_nil
      end
    end
  end

  describe "#form_of_work" do
    context "when there is a form of work" do
      subject(:form_of_work_value) do
        document = described_class.new(marc_ss: form_of_work)
        document.form_of_work
      end

      it "will return the form of work" do
        expect(form_of_work_value).to include "Interviews"
      end
    end

    context "when there is no form of work" do
      subject(:form_of_work_value) do
        document = described_class.new(marc_ss: single_series)
        document.form_of_work
      end

      it "will return nil" do
        expect(form_of_work_value).to eq []
      end
    end
  end

  describe "#translated_title" do
    context "when there are translated titles" do
      subject(:translated_title_value) do
        document = described_class.new(marc_ss: translated_title)
        document.translated_title
      end

      it "will return the concatenated title" do
        expect(translated_title_value).to eq [<<~STRING.squish
          Promoting a Healthy Future [microform] : Training Manual for Health 
          Educators and Instructors Who Work with Young Health Promoters, Young Counselors or Educators and
          Volunteers / Carmen Duran and Paloma Cuchi.
        STRING
        ]
      end
    end

    context "when there are no translated titles" do
      subject(:translated_title_value) do
        document = described_class.new(marc_ss: single_series)
        document.translated_title
      end

      it "will return an empty array" do
        expect(translated_title_value).to eq []
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

  def no_notes
    IO.read("spec/files/marc/3079596.marcxml")
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

  def form_of_work
    IO.read("spec/files/marc/7291584.marcxml")
  end

  def translated_title
    IO.read("spec/files/marc/5673402.marcxml")
  end
end
