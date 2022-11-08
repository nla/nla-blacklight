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

        expect(map_search_value).to eq []
      end
    end

    context "when there is no 'format'" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: no_format)
        document.map_search
      end

      it "does not generate a link to Map Search" do
        expect(map_search_value).to eq []
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
        expect(series_value).to eq [
          "Australian National Audit Office. Audit report ; 2005-2006, no. 16",
          "Australian National Audit Office. Performance report",
          "Auditor-General audit report ; no. 16, 2005-2006",
          "Performance audit / Australian National Audit Office",
          "Parliamentary paper (Australia. Parliament) ; 2005, no. 434."
        ]
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

  describe "#copyright_info" do
    subject(:copyright_info_value) do
      document.copyright_info
    end

    let(:document) { described_class.new(marc_ss: form_of_work, id: 7291584) }

    it "will return the copyright information for the work" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))

      WebMock.stub_request(:get, "https://example.com/copyright/")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v1.10.0"
          }
        )
        .to_return(status: 200, body: IO.read("spec/files/copyright/service_response.xml").to_s, headers: {})

      expect(copyright_info_value.info).not_to be_nil
      expect(copyright_info_value.info["contextMsg"]).to eq "1.1"
    end
  end

  describe "#form_of_work" do
    context "when there is a form of work" do
      subject(:form_of_work_value) do
        document = described_class.new(marc_ss: form_of_work)
        document.form_of_work
      end

      it "will return the form of work" do
        expect(form_of_work_value).not_to be_nil
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

  describe "#uniform_title" do
    context "when there is a uniform title in subfield 130" do
      subject(:uniform_title_value) do
        document = described_class.new(marc_ss: uniform_title_130)
        document.uniform_title
      end

      it "will display the uniform title" do
        expect(uniform_title_value).to eq ["Wort Hesed. English."]
      end
    end

    context "when there is no uniform title in subfield 130" do
      subject(:uniform_title_value) do
        document = described_class.new(marc_ss: uniform_title_240)
        document.uniform_title
      end

      it "will look in subfield 240 and display the uniform title" do
        expect(uniform_title_value).to eq ["De foto's van Jongensjaren. Spanish"]
      end
    end

    context "when there is no uniform title in subfield 130 or subfield 240" do
      subject(:uniform_title_value) do
        document = described_class.new(marc_ss: single_series)
        document.uniform_title
      end

      it "will return an empty array" do
        expect(uniform_title_value).to eq []
      end
    end
  end

  describe "#edition" do
    context "when there is an edition in subfield 250" do
      subject(:edition_value) do
        document = described_class.new(marc_ss: edition)
        document.edition
      end

      it "will return the edition" do
        expect(edition_value).to eq ["3d ed."]
      end
    end

    context "when there is an edition in subfield 880 and subfield 250" do
      subject(:edition_value) do
        document = described_class.new(marc_ss: edition_880)
        document.edition
      end

      it "will return both editions" do
        expect(edition_value).to eq ["Chu ban", "初版"]
      end

      it "will return the 880 value first" do
        expect(edition_value.first).to eq "Chu ban"
      end
    end
  end

  describe "#access_conditions" do
    context "when there is an access condition" do
      subject(:access_condition_value) do
        document = described_class.new(marc_ss: access_condition)
        document.access_conditions
      end

      it "will return the access condition" do
        expect(access_condition_value).to eq [<<~STRING.squish
          "This document has been distributed to a limited audience for a limited purpose. It is not published"--P. [2] of cover.
        STRING
        ]
      end
    end

    context "when there is an eResources copy" do
      subject(:access_condition_value) do
        document = described_class.new(marc_ss: access_condition_with_eresources)
        document.access_conditions
      end

      it "will not return an access condition" do
        expect(access_condition_value).to eq []
      end
    end
  end

  describe "#scale" do
    context "when there is scale" do
      subject(:scale_value) do
        document = described_class.new(marc_ss: scale)
        document.scale
      end

      it "will return the scale" do
        expect(scale_value).to eq ["Scale [1:31,680]. Two inches to a mile (E 145°20'--E 145°45'/S 38°15'--S 38°30')"]
      end
    end

    context "when there is no scale" do
      subject(:scale_value) do
        document = described_class.new(marc_ss: access_condition)
        document.scale
      end

      it "will return an empty array" do
        expect(scale_value).to eq []
      end
    end
  end

  describe "#isbn" do
    context "when there is an ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn)
        document.isbn
      end

      it "will return the ISBN" do
        expect(isbn_value).to eq ["0855507322 (corrected)", "0855507403", "1111 (dummy)"]
      end
    end

    context "when there is a linked 880" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn)
        document.isbn
      end

      it "will return the ISBN" do
        expect(isbn_value).to include "1111 (dummy)"
      end
    end

    context "when there are more than one ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: multiple_isbn)
        document.isbn
      end

      it "will return all the ISBN" do
        expect(isbn_value).to eq ["0855507322 (corrected)", "0855507403", "1111 (dummy)"]
      end
    end

    context "when there is a qualifier" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: multiple_isbn)
        document.isbn
      end

      it "will append it after the ISBN" do
        expect(isbn_value.first).to include " (corrected)"
      end
    end

    context "when there is no ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: invalid_issn)
        document.isbn
      end

      it "will return an empty array" do
        expect(isbn_value).to eq []
      end
    end

    context "when there is extra punctuation around the ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn_format)
        document.isbn
      end

      it "will strip extra punctuation around the ISBN" do
        expect(isbn_value).to eq ["9781478007364 (electronic book)", "1478007362 (electronic book)"]
      end
    end
  end

  describe "#invalid_isbn" do
    context "when there is an invalid ISBN" do
      subject(:invalid_isbn_value) do
        document = described_class.new(marc_ss: invalid_isbn)
        document.invalid_isbn
      end

      it "will return the invalid ISBN" do
        expect(invalid_isbn_value).to eq ["0855504404", "085550448X (corrected) (soft)"]
      end
    end

    context "when there are more than one ISBN" do
      subject(:invalid_isbn_value) do
        document = described_class.new(marc_ss: invalid_isbn)
        document.invalid_isbn
      end

      it "will return all the invalid ISBNs in a single string" do
        expect(invalid_isbn_value).to eq ["0855504404", "085550448X (corrected) (soft)"]
      end
    end

    context "when there is a qualifier" do
      subject(:invalid_isbn_value) do
        document = described_class.new(marc_ss: invalid_isbn)
        document.invalid_isbn
      end

      it "will append it after the invalid ISBN" do
        expect(invalid_isbn_value[1]).to include " (corrected) (soft)"
      end
    end

    context "when there is no invalid ISBN" do
      subject(:invalid_isbn_value) do
        document = described_class.new(marc_ss: issn)
        document.invalid_isbn
      end

      it "will return an empty array" do
        expect(invalid_isbn_value).to eq []
      end
    end

    context "when there is extra punctuation around the invalid ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn_format)
        document.invalid_isbn
      end

      it "will strip extra punctuation around the ISBN" do
        expect(isbn_value).to eq [
          "9781478005773 (hardcover) (alkaline paper)",
          "1478006676 (hardcover) (alkaline paper)",
          "9781478006671 (paperback) (alkaline paper)",
          "1478005777 (hardcover ;) (alkaline paper)"
        ]
      end
    end
  end

  describe "#issn" do
    context "when there is an ISSN" do
      subject(:issn_value) do
        document = described_class.new(marc_ss: issn)
        document.issn
      end

      it "will return the ISSN" do
        expect(issn_value).to eq %w[0000-0442]
      end
    end

    context "when there is no ISSN" do
      subject(:invalid_issn_value) do
        document = described_class.new(marc_ss: invalid_isbn)
        document.invalid_issn
      end

      it "will return an empty array" do
        expect(invalid_issn_value).to eq []
      end
    end
  end

  describe "#invalid_iissn" do
    context "when there is an invalid ISSN" do
      subject(:invalid_issn_value) do
        document = described_class.new(marc_ss: invalid_issn)
        document.invalid_issn
      end

      it "will return the ISSN" do
        expect(invalid_issn_value).to eq %w[0318-2606 0844-837X]
      end
    end

    context "when there is no invalid ISSN" do
      subject(:invalid_issn_value) do
        document = described_class.new(marc_ss: isbn)
        document.invalid_issn
      end

      it "will return an empty array" do
        expect(invalid_issn_value).to eq []
      end
    end
  end

  describe "#ismn" do
    context "when there is an ISMN" do
      subject(:ismn_value) do
        document = described_class.new(marc_ss: ismn)
        document.ismn
      end

      it "will return the ISMN" do
        expect(ismn_value).to eq ["9790720160313"]
      end
    end

    context "when there is no ISMN" do
      subject(:ismn_value) do
        document = described_class.new(marc_ss: issn)
        document.ismn
      end

      it "will return an empty array" do
        expect(ismn_value).to eq []
      end
    end
  end

  describe "#invalid_ismn" do
    context "when there is an ISMN" do
      subject(:invalid_ismn_value) do
        document = described_class.new(marc_ss: invalid_ismn)
        document.invalid_ismn
      end

      it "will return the invalid ISMN" do
        expect(invalid_ismn_value).not_to eq []
      end
    end

    context "when there are multiple ISMNs" do
      subject(:invalid_ismn_value) do
        document = described_class.new(marc_ss: invalid_ismn)
        document.invalid_ismn
      end

      it "will return all the invalid ISMNs" do
        expect(invalid_ismn_value).to eq %w[M720067568 M72005967568]
      end
    end

    context "when there is no IMSN" do
      subject(:invalid_ismn_value) do
        document = described_class.new(marc_ss: issn)
        document.invalid_ismn
      end

      it "will return an empty array" do
        expect(invalid_ismn_value).to eq []
      end
    end
  end

  describe "#printer" do
    context "when there is a printer" do
      subject(:printer_value) do
        document = described_class.new(marc_ss: access_condition_with_eresources)
        document.printer
      end

      it "will return the printer text" do
        expect(printer_value).to include "([New Brunswick, N.J.] : L. Deane)"
      end
    end
  end

  describe "#full_contents" do
    context "when there is a contents list" do
      subject(:full_contents_value) do
        document = described_class.new(marc_ss: full_contents)
        document.full_contents
      end

      it "will return the list of contents" do
        expect(full_contents_value.size).to(eq(2))
      end
    end
  end

  describe "#technical_details" do
    context "when there are technical details" do
      subject(:technical_details_value) do
        document = described_class.new(marc_ss: technical_details)
        document.technical_details
      end

      it "will return the technical details in a single string" do
        expect(technical_details_value).to eq ["Mode of access: Available online. Address as at 25/08/14: http://www.coagreformcouncil.gov.au/reports/housing.html"]
      end
    end

    context "when there are no technical details" do
      subject(:technical_details_value) do
        document = described_class.new(marc_ss: access_condition_with_eresources)
        document.technical_details
      end

      it "will return an empty array" do
        expect(technical_details_value).to eq []
      end
    end
  end

  private

  def single_series
    load_marc_from_file 109692
  end

  def multiple_series
    load_marc_from_file 8126677
  end

  def single_note
    load_marc_from_file 1068705
  end

  def multiple_notes
    load_marc_from_file 8174421
  end

  def no_notes
    load_marc_from_file 3079596
  end

  def online_access
    load_marc_from_file 4806783
  end

  def map_search
    load_marc_from_file 113030
  end

  def no_map_search
    load_marc_from_file 3647081
  end

  def no_format
    load_marc_from_file 7251259
  end

  def form_of_work
    load_marc_from_file 7291584
  end

  def translated_title
    load_marc_from_file 5673402
  end

  def uniform_title_130
    load_marc_from_file 561972
  end

  def uniform_title_240
    load_marc_from_file 8662981
  end

  def edition
    load_marc_from_file 1336868
  end

  def edition_880
    load_marc_from_file 6290058
  end

  def access_condition
    load_marc_from_file 3926789
  end

  def access_condition_with_eresources
    load_marc_from_file 3755597
  end

  def scale
    load_marc_from_file 4315761
  end

  def isbn
    load_marc_from_file 1868021
  end

  def multiple_isbn
    load_marc_from_file 1868021
  end

  def invalid_isbn
    load_marc_from_file 1868021
  end

  def isbn_format
    load_marc_from_file 8420291
  end

  def issn
    load_marc_from_file 28336
  end

  def invalid_issn
    load_marc_from_file 3022824
  end

  def ismn
    load_marc_from_file 8665709
  end

  def invalid_ismn
    load_marc_from_file 4773335
  end

  def full_contents
    load_marc_from_file 1455669
  end

  def technical_details
    load_marc_from_file 6154492
  end
end
