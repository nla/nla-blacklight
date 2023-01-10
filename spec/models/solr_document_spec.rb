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
              "User-Agent" => "Faraday v2.7.1"
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
              "User-Agent" => "Faraday v2.7.1"
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
      document.copyright_status
    end

    let(:document) { described_class.new(marc_ss: form_of_work, id: 7291584) }

    it "will return the copyright information for the work" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))

      WebMock.stub_request(:get, "https://example.com/copyright/")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v2.7.1"
          }
        )
        .to_return(status: 200, body: IO.read("spec/files/copyright/service_response.xml").to_s, headers: {})

      expect(copyright_info_value.info).not_to be_nil
      expect(copyright_info_value.info["contextMsg"]).to eq "1.1"
    end

    context "when no copyright info is returned by the SOA" do
      it "will return nil" do
        stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))

        WebMock.stub_request(:get, "https://example.com/copyright/")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v2.7.1"
            }
          )
          .to_return(status: 502, body: "", headers: {})

        expect(copyright_info_value).to be_nil
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

    context "when the 264 field does not have an indicator2 value of 3" do
      subject(:printer_value) do
        document = described_class.new(marc_ss: printer_264)
        document.printer
      end

      it "will return an empty array" do
        expect(printer_value).to eq []
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
        expect(full_contents_value.size).to(eq(25))
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

  describe "#summary" do
    context "when there are summaries" do
      subject(:summary_value) do
        document = described_class.new(marc_ss: summary)
        document.summary
      end

      it "will return an array of summaries" do
        expect(summary_value.size).to eq 2
      end
    end

    context "when there are summaries in linked 880 fields" do
      subject(:summary_value) do
        document = described_class.new(marc_ss: summary_880)
        document.summary
      end

      it "will return the summary in the 880 field" do
        expect(summary_value.size).to eq 2
      end
    end

    context "when there are no summaries" do
      subject(:summary_value) do
        document = described_class.new(marc_ss: issn)
        document.summary
      end

      it "will return an empty array" do
        expect(summary_value).to eq []
      end
    end
  end

  describe "#partial_contents" do
    context "when there are partial contents" do
      subject(:partial_contents_value) do
        document = described_class.new(marc_ss: partial_contents)
        document.partial_contents
      end

      it "will render the full list of contents" do
        expect(partial_contents_value.size).to eq 9
      end
    end

    context "when there are no partial contents" do
      subject(:partial_contents_value) do
        document = described_class.new(marc_ss: full_contents)
        document.partial_contents
      end

      it "will return an empty array" do
        expect(partial_contents_value).to eq []
      end
    end
  end

  describe "#incomplete_contents" do
    context "when there are incomplete contents" do
      subject(:incomplete_contents_value) do
        document = described_class.new(marc_ss: incomplete_contents)
        document.incomplete_contents
      end

      it "will return all the incomplete contents" do
        expect(incomplete_contents_value.size).to eq 4
      end
    end

    context "when there are no incomplete contents" do
      subject(:incomplete_contents_value) do
        document = described_class.new(marc_ss: full_contents)
        document.incomplete_contents
      end

      it "will return an empty array" do
        expect(incomplete_contents_value).to eq []
      end
    end
  end

  describe "#credits" do
    context "when there are credits" do
      subject(:credits_value) do
        document = described_class.new(marc_ss: credits)
        document.credits
      end

      it "will return all the credits" do
        expect(credits_value.size).to eq 2
      end
    end

    context "when there are no credits" do
      subject(:credits_value) do
        document = described_class.new(marc_ss: full_contents)
        document.credits
      end

      it "will return an empty array" do
        expect(credits_value).to eq []
      end
    end
  end

  describe "#performers" do
    context "when there are performers" do
      subject(:performers_value) do
        document = described_class.new(marc_ss: performers)
        document.performers
      end

      it "will return all performers" do
        expect(performers_value).to eq ["Keith Bowen.", "Jeremy Ashton.", "Carol Shelbourn."]
      end
    end

    context "when there are no performers" do
      subject(:performers_value) do
        document = described_class.new(marc_ss: full_contents)
        document.performers
      end

      it "will return an empty array" do
        expect(performers_value).to eq []
      end
    end
  end

  describe "#biography_history" do
    context "when there are biographies or histories" do
      subject(:biography_history_value) do
        document = described_class.new(marc_ss: biography_history)
        document.biography_history
      end

      it "will return all biographies/histories" do
        expect(biography_history_value.size).to eq 3
      end
    end

    context "when there is no biography or history" do
      subject(:biography_history_value) do
        document = described_class.new(marc_ss: performers)
        document.biography_history
      end

      it "will return an empty array" do
        expect(biography_history_value).to eq []
      end
    end
  end

  describe "#numbering_note" do
    context "when there are numbering notes" do
      subject(:numbering_note_value) do
        document = described_class.new(marc_ss: numbering_note)
        document.numbering_note
      end

      it "will return all numbering notes" do
        expect(numbering_note_value.size).to eq 3
      end
    end

    context "when there are no numbering notes" do
      subject(:numbering_note_value) do
        document = described_class.new(marc_ss: performers)
        document.numbering_note
      end

      it "will return an empty array" do
        expect(numbering_note_value).to eq []
      end
    end
  end

  describe "#data_quality" do
    context "when there are data quality information" do
      subject(:data_quality_value) do
        document = described_class.new(marc_ss: data_quality)
        document.data_quality
      end

      it "will return all data quality information" do
        expect(data_quality_value).to eq ["Last copy of this item within Australia."]
      end
    end

    context "when there is no data quality information" do
      subject(:data_quality_value) do
        document = described_class.new(marc_ss: performers)
        document.data_quality
      end

      it "will return an empty array" do
        expect(data_quality_value).to eq []
      end
    end
  end

  describe "#binding_information" do
    context "when there is binding information" do
      subject(:binding_information_value) do
        document = described_class.new(marc_ss: binding_information)
        document.binding_information
      end

      it "will return all binding information" do
        expect(binding_information_value.size).to eq 2
      end
    end

    context "when there is no binding information" do
      subject(:binding_information_value) do
        document = described_class.new(marc_ss: performers)
        document.binding_information
      end

      it "will return an empty array" do
        expect(binding_information_value).to eq []
      end
    end

    context "when there is linked 880 field" do
      subject(:binding_information_value) do
        document = described_class.new(marc_ss: binding_information)
        document.binding_information
      end

      it "will return the linked 880 value" do
        expect(binding_information_value[1]).to eq "平裝"
      end
    end
  end

  describe "#related_material" do
    context "when there is related material" do
      subject(:related_material_value) do
        document = described_class.new(marc_ss: related_material)
        document.related_material
      end

      it "will return all the related material" do
        expect(related_material_value.size).to eq 5
      end
    end

    context "when there is no related material" do
      subject(:related_material_value) do
        document = described_class.new(marc_ss: binding_information)
        document.related_material
      end

      it "will return an empty array" do
        expect(related_material_value).to eq []
      end
    end
  end

  describe "#provenance" do
    context "when there is provenance" do
      subject(:provenance_value) do
        document = described_class.new(marc_ss: provenance)
        document.provenance
      end

      it "will return all the provenance information" do
        expect(provenance_value.size).to eq 2
      end
    end

    context "when there is no provenance" do
      subject(:provenance_value) do
        document = described_class.new(marc_ss: binding_information)
        document.provenance
      end

      it "will return an empty array" do
        expect(provenance_value).to eq []
      end
    end
  end

  describe "#govt_doc_number" do
    context "when there are government document numbers" do
      subject(:govt_doc_number_value) do
        document = described_class.new(marc_ss: govt_doc_number)
        document.govt_doc_number
      end

      it "will return all the government document numbers" do
        expect(govt_doc_number_value.size).to eq 2
      end
    end

    context "when there are no government document numbers" do
      subject(:govt_doc_number_value) do
        document = described_class.new(marc_ss: provenance)
        document.govt_doc_number
      end

      it "will return an empty array" do
        expect(govt_doc_number_value).to eq []
      end
    end
  end

  describe "#music_publisher_number" do
    context "when there are music publisher numbers" do
      subject(:music_publisher_number_value) do
        document = described_class.new(marc_ss: music_publisher_number)
        document.music_publisher_number
      end

      it "will return all the music publisher numbers" do
        expect(music_publisher_number_value.size).to eq 3
      end
    end

    context "when there are no music publisher numbers" do
      subject(:music_publisher_number_value) do
        document = described_class.new(marc_ss: provenance)
        document.music_publisher_number
      end

      it "will return an empty array" do
        expect(music_publisher_number_value).to eq []
      end
    end
  end

  describe "#exhibited" do
    context "when there are exhibitions" do
      subject(:exhibited_value) do
        document = described_class.new(marc_ss: exhibition_info)
        document.exhibited
      end

      it "will return all exibitions" do
        expect(exhibited_value.size).to eq 3
      end
    end

    context "when there are no exhibitions" do
      subject(:exhibited_value) do
        document = described_class.new(marc_ss: provenance)
        document.exhibited
      end

      it "will return an empty array" do
        expect(exhibited_value).to eq []
      end
    end
  end

  describe "#acknowledgement" do
    context "when there are acknowledgements" do
      subject(:acknowledgement_value) do
        document = described_class.new(marc_ss: acknowledgements)
        document.acknowledgement
      end

      it "will return all acknowledgements" do
        expect(acknowledgement_value).to eq ["Microfilmed with the generous support of Dr Diana Carroll."]
      end
    end

    context "when there are no exhibitions" do
      subject(:acknowledgement_value) do
        document = described_class.new(marc_ss: music_publisher_number)
        document.acknowledgement
      end

      it "will return an empty array" do
        expect(acknowledgement_value).to eq []
      end
    end
  end

  describe "#cited_in" do
    context "when there are citations" do
      subject(:cited_in_value) do
        document = described_class.new(marc_ss: cited_in)
        document.cited_in
      end

      it "will return all citations" do
        expect(cited_in_value.size).to eq 2
      end

      it "will return linked 880" do
        expect(cited_in_value).to include "For contents see \"中國叢書綜錄\", 1:307."
      end
    end

    context "when there are no citations" do
      subject(:cited_in_value) do
        document = described_class.new(marc_ss: provenance)
        document.cited_in
      end

      it "will return an empty array" do
        expect(cited_in_value).to eq []
      end
    end
  end

  describe "#reproduction" do
    context "when there are reproductions" do
      subject(:reproduction_value) do
        document = described_class.new(marc_ss: reproductions)
        document.reproduction
      end

      it "will return all reproductions" do
        expect(reproduction_value.size).to eq 2
      end

      it "will return linked 880" do
        expect(reproduction_value).to include "Photo-offset. 香港?, 1970?. 19 cm."
      end
    end

    context "when there are no reproductions" do
      subject(:reproduction_value) do
        document = described_class.new(marc_ss: cited_in)
        document.reproduction
      end

      it "will return an empty array" do
        expect(reproduction_value).to eq []
      end
    end
  end

  describe "#has_subseries" do
    context "when there are subseries" do
      subject(:has_subseries_value) do
        document = described_class.new(marc_ss: has_subseries_info)
        document.has_subseries
      end

      it "will return all subseries" do
        expect(has_subseries_value.size).to eq 6
      end
    end

    context "when there are no subseries" do
      subject(:has_subseries_value) do
        document = described_class.new(marc_ss: cited_in)
        document.has_subseries
      end

      it "will return an empty array" do
        expect(has_subseries_value).to eq []
      end
    end
  end

  describe "#subseries_of" do
    context "when there are series" do
      subject(:subseries_of_value) do
        document = described_class.new(marc_ss: subseries_of_info)
        document.subseries_of
      end

      it "will return all series" do
        expect(subseries_of_value.size).to eq 2
      end
    end

    context "when there are no series" do
      subject(:subseries_of_value) do
        document = described_class.new(marc_ss: reproductions)
        document.subseries_of
      end

      it "will return an empty array" do
        expect(subseries_of_value).to eq []
      end
    end
  end

  describe "#available_from" do
    context "when there are sources" do
      subject(:available_from_value) do
        document = described_class.new(marc_ss: available_from)
        document.available_from
      end

      it "will return all sources" do
        expect(available_from_value.size).to eq 2
      end
    end

    context "when there are no sources" do
      subject(:available_from_value) do
        document = described_class.new(marc_ss: subseries_of_info)
        document.available_from
      end

      it "will return an empty array" do
        expect(available_from_value).to eq []
      end
    end
  end

  describe "#awards" do
    context "when there are awards" do
      subject(:awards_value) do
        document = described_class.new(marc_ss: awards)
        document.awards
      end

      it "will return all awards" do
        expect(awards_value.size).to eq 2
      end
    end

    context "when there are no awards" do
      subject(:awards_value) do
        document = described_class.new(marc_ss: reproductions)
        document.awards
      end

      it "will return an empty array" do
        expect(awards_value).to eq []
      end
    end
  end

  describe "#related_title" do
    context "when there are related titles" do
      subject(:related_title_value) do
        document = described_class.new(marc_ss: related_title)
        document.related_title
      end

      it "will return all related titles" do
        expect(related_title_value.size).to eq 2
      end
    end

    context "when there are no related titles" do
      subject(:related_title_value) do
        document = described_class.new(marc_ss: awards)
        document.related_title
      end

      it "will return an exmpty array" do
        expect(related_title_value).to eq []
      end
    end
  end

  describe "#issued_with" do
    context "when there are related issues" do
      subject(:issued_with_value) do
        document = described_class.new(marc_ss: issued_with)
        document.issued_with
      end

      it "will return all related issues" do
        expect(issued_with_value.size).to eq 2
      end
    end

    context "when there are no related issues" do
      subject(:issued_with_value) do
        document = described_class.new(marc_ss: awards)
        document.issued_with
      end

      it "will return an empty array" do
        expect(issued_with_value).to eq []
      end
    end
  end

  describe "#frequency" do
    context "when there are frequencies" do
      subject(:frequency_value) do
        document = described_class.new(marc_ss: frequency)
        document.frequency
      end

      it "will return all frequencies" do
        expect(frequency_value.size).to eq 2
      end

      it "will return linked 880 subfields" do
        expect(frequency_value).to include "月刊"
      end
    end

    context "when there are no frequencies" do
      subject(:frequency_value) do
        document = described_class.new(marc_ss: awards)
        document.frequency
      end

      it "will return an empty array" do
        expect(frequency_value).to eq []
      end
    end
  end

  describe "#previous_frequency" do
    context "when there are previous frequencies" do
      subject(:previous_frequency_value) do
        document = described_class.new(marc_ss: previous_frequency)
        document.previous_frequency
      end

      it "will return all the previous frequencies" do
        expect(previous_frequency_value.size).to eq 2
      end

      it "will return linked 880 subfields" do
        expect(previous_frequency_value).to include "旬刊"
      end
    end

    context "when there are no previous frequencies" do
      subject(:previous_frequency_value) do
        document = described_class.new(marc_ss: awards)
        document.previous_frequency
      end

      it "will return an empty array" do
        expect(previous_frequency_value).to eq []
      end
    end
  end

  describe "#index_finding_aid_note" do
    context "when there are finding aid notes" do
      subject(:index_finding_aid_note_value) do
        document = described_class.new(marc_ss: index_finding_aid_note)
        document.index_finding_aid_note
      end

      it "will return all index/finding aid notes" do
        expect(index_finding_aid_note_value.size).to eq 5
      end
    end

    context "when there are no index/finding aid notes" do
      subject(:index_finding_aid_note_value) do
        document = described_class.new(marc_ss: awards)
        document.index_finding_aid_note
      end

      it "will return an empty array" do
        expect(index_finding_aid_note_value).to eq []
      end
    end
  end

  describe "#genre" do
    context "when there are forms/genres" do
      subject(:genre_value) do
        document = described_class.new(marc_ss: genre)
        document.genre
      end

      it "will return all forms/genres" do
        expect(genre_value.size).to eq 3
      end
    end

    context "when there are no forms/genres" do
      subject(:genre_value) do
        document = described_class.new(marc_ss: index_finding_aid_note)
        document.genre
      end

      it "will return an empty array" do
        expect(genre_value).to eq []
      end
    end
  end

  describe "#place" do
    context "when there are places" do
      subject(:place_value) do
        document = described_class.new(marc_ss: place)
        document.place
      end

      it "will return all places" do
        expect(place_value.size).to eq 2
      end
    end

    context "when there are no places" do
      subject(:place_value) do
        document = described_class.new(marc_ss: genre)
        document.place
      end

      it "will return an empty array" do
        expect(place_value).to eq []
      end
    end
  end

  describe "#has_supplement" do
    context "when there are supplements" do
      subject(:supplement_value) do
        document = described_class.new(marc_ss: has_supplement)
        document.has_supplement
      end

      it "will return all supplements" do
        expect(supplement_value.size).to eq 4
      end
    end

    context "when there are no supplements" do
      subject(:supplement_value) do
        document = described_class.new(marc_ss: place)
        document.has_supplement
      end

      it "will return an empty array" do
        expect(supplement_value).to eq []
      end
    end
  end

  describe "#supplement_to" do
    context "when there are supplements" do
      subject(:supplement_value) do
        document = described_class.new(marc_ss: supplement_to)
        document.supplement_to
      end

      it "will return all supplements" do
        expect(supplement_value.size).to eq 2
      end
    end

    context "when there are no supplements" do
      subject(:supplement_value) do
        document = described_class.new(marc_ss: place)
        document.supplement_to
      end

      it "will return an empty array" do
        expect(supplement_value).to eq []
      end
    end
  end

  describe "#new_title" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: later_title)
        document.new_title
      end

      it "will return all titles" do
        expect(title_value.size).to eq 2
      end
    end

    context "when there are no titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: supplement_to)
        document.new_title
      end

      it "will return an empty array" do
        expect(title_value).to eq []
      end
    end
  end

  describe "#old_title" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: former_title)
        document.old_title
      end

      it "will return all titles" do
        expect(title_value.size).to eq 4
      end
    end

    context "when there are no titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: later_title)
        document.old_title
      end

      it "will return an empty array" do
        expect(title_value).to eq []
      end
    end
  end

  describe "#also_titled" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: also_titled)
        document.also_titled
      end

      it "will return all the titles" do
        expect(title_value.size).to eq 2
      end
    end

    context "when there are no titles" do
      subject(:title_value) do
        document = described_class.new(marc_ss: place)
        document.also_titled
      end

      it "will return an empty array" do
        expect(title_value).to eq []
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

  def printer_264
    load_marc_from_file 7326111
  end

  def full_contents
    load_marc_from_file 1455669
  end

  def technical_details
    load_marc_from_file 6154492
  end

  def summary
    load_marc_from_file 156059
  end

  def summary_880
    load_marc_from_file 6022968
  end

  def partial_contents
    load_marc_from_file 4838379
  end

  def incomplete_contents
    load_marc_from_file 4864988
  end

  def credits
    load_marc_from_file 778088
  end

  def performers
    load_marc_from_file 363909
  end

  def biography_history
    load_marc_from_file 5497731
  end

  def numbering_note
    load_marc_from_file 2208462
  end

  def data_quality
    load_marc_from_file 8539536
  end

  def binding_information
    load_marc_from_file 5744995
  end

  def related_material
    load_marc_from_file 8548630
  end

  def provenance
    load_marc_from_file 8065222
  end

  def govt_doc_number
    load_marc_from_file 3823089
  end

  def music_publisher_number
    load_marc_from_file 3356244
  end

  def exhibition_info
    load_marc_from_file 6453708
  end

  def acknowledgements
    load_marc_from_file 4464657
  end

  def cited_in
    load_marc_from_file 5784759
  end

  def reproductions
    load_marc_from_file 2904384
  end

  def has_subseries_info
    load_marc_from_file 2036712
  end

  def subseries_of_info
    load_marc_from_file 2647507
  end

  def available_from
    load_marc_from_file 23706
  end

  def awards
    load_marc_from_file 7328922
  end

  def related_title
    load_marc_from_file 620407
  end

  def issued_with
    load_marc_from_file 1475436
  end

  def frequency
    load_marc_from_file 4604577
  end

  def previous_frequency
    load_marc_from_file 4651293
  end

  def index_finding_aid_note
    load_marc_from_file 773963
  end

  def genre
    load_marc_from_file 5474602
  end

  def place
    load_marc_from_file 3754127
  end

  def has_supplement
    load_marc_from_file 1125877
  end

  def supplement_to
    load_marc_from_file 1090172
  end

  def later_title
    load_marc_from_file 2142448
  end

  def former_title
    load_marc_from_file 2181169
  end

  def also_titled
    load_marc_from_file 4327251
  end
end
