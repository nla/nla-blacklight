require "rails_helper"

RSpec.describe SolrDocument do
  describe "#access_conditions" do
    context "when there is an access condition" do
      subject(:access_condition_value) do
        document = described_class.new(
          marc_ss: access_condition,
          access_conditions_ssim: ["\"This document has been distributed to a limited audience for a limited purpose. It is not published\"--P. [2] of cover."]
        )
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
        document = described_class.new(
          marc_ss: access_condition_with_eresources,
          access_conditions_ssim: ["Subscription and registration required for access."]
        )
        document.access_conditions
      end

      it "will not return an access condition" do
        expect(access_condition_value).to be_nil
      end
    end
  end

  describe "#acknowledgement" do
    context "when there are acknowledgements" do
      subject(:acknowledgement_value) do
        document = described_class.new(
          marc_ss: acknowledgements,
          acknowledgement_tsim: ["Microfilmed with the generous support of Dr Diana Carroll."]
        )
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

      it "will return nil" do
        expect(acknowledgement_value).to eq []
      end
    end
  end

  describe "#also_titled" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(
          marc_ss: also_titled,
          also_titled_tsim: ["Filing title: Keathley Canyon", "Gulf of Mexico, Keathley Canyon"]
        )
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

      it "will return nil" do
        expect(title_value).to eq []
      end
    end
  end

  describe "#available_from" do
    context "when there are sources" do
      subject(:available_from_value) do
        document = described_class.new(
          marc_ss: available_from,
          available_from_tsim: ["University Microfilms International",
            "University Microfilms International, 300 N. Zeeb Rd., Ann Arbor, MI 48106"]
        )
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

      it "will return nil" do
        expect(available_from_value).to eq []
      end
    end
  end

  describe "#awards" do
    context "when there are awards" do
      subject(:awards_value) do
        document = described_class.new(
          marc_ss: awards,
          awards_tsim: ["Dai 53-kai Shōgakukan Jidō Shuppan Bunkashō, 2004",
            "Dai 36-kai Kōdansha Shuppan Bunkashō Ehonshō, 2005"]
        )
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

      it "will return nil" do
        expect(awards_value).to eq []
      end
    end
  end

  describe "#binding_information" do
    context "when there is binding information" do
      subject(:binding_information_value) do
        document = described_class.new(
          marc_ss: binding_information,
          binding_tsim: ["Ping zhuang.", "平裝"]
        )
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

      it "will return nil" do
        expect(binding_information_value).to eq []
      end
    end

    context "when there is linked 880 field" do
      subject(:binding_information_value) do
        document = described_class.new(
          marc_ss: binding_information,
          binding_tsim: ["Ping zhuang.", "平裝"]
        )
        document.binding_information
      end

      it "will return the linked 880 value" do
        expect(binding_information_value[1]).to eq "平裝"
      end
    end
  end

  describe "#biography_history" do
    context "when there are biographies or histories" do
      subject(:biography_history_value) do
        document = described_class.new(
          marc_ss: biography_history,
          biography_history_tsim: ["Novelist and short story writer William Alan Marshall was born in Noorat, Victoria, in 1902. He contracted polio at the age of six, which left him with a permanent physical disability requiring crutches or a wheelchair. His works include I can jump puddles (1955), This is the grass (1962) and In mine own heart (1963). He was awarded the Order of the British Empire and an honorary Doctor of Laws degree from Melbourne University in 1972. In 1981, he was made a Member of the Order of Australia (AM) for service to literature. Marshall died in 1984.",
            "Painter, cartoonist, illustrator and writer. Born in Melbourne, Jack Noel Counihan was an artist noted for his social-realist style and radical outlook, whose work has been widely exhibited in Australia and overseas. An active member of the Communist Party, Counihan was also a foundation member of the Print Council of Australia, and served as the latter's president between 1973 and 1978.",
            "Jenny Hadlow (née Hackett) grew up on her family's farm, \"Thistlebank\", at Goodnight, New South Wales, on the Murray River. She married Barrie Hadlow of Swan Hill in 1961. In 1970, they moved with their young family to Canberra, where Barrie was studying and working in horticulture. Jenny Hadlow worked for the Australian Red Cross Society (A.C.T.) for 26 years."]
        )
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

      it "will return nil" do
        expect(biography_history_value).to eq []
      end
    end

    context "when there is a url in the biography or history" do
      subject(:biography_history_value) do
        document = described_class.new(
          marc_ss: biography_history_with_url,
          biography_history_tsim: ["Statistican, public servant and writer. Timothy Augustine Coghlan was born in Sydney in 1855. He served as the first government statistician of New South Wales, 1886-1905, until appointed as New South Wales agent-general in London, 1905-1926. Coghlan was the author of Wealth and progress of New South Wales (1887), Labour and industry in Australia (1918) and many other works. He was also a member of many associations and government advisory bodies. Further biographical information at http://trove.nla.gov.au/people/617455"]
        )
        document.biography_history
      end

      it "will return the url" do
        expect(biography_history_value.size).to eq 1
        expect(biography_history_value.first).to include("http://trove.nla.gov.au/people/617455")
      end
    end
  end

  describe "#cited_in" do
    context "when there are citations" do
      subject(:cited_in_value) do
        document = described_class.new(
          marc_ss: cited_in,
          cited_in_tsim: ["For contents see \"Zhongguo cong shu zong lu\", 1:307.",
            "For contents see \"中國叢書綜錄\", 1:307."]
        )
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

      it "will return nil" do
        expect(cited_in_value).to eq []
      end
    end
  end

  describe "#copy_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there is an online copy" do
      subject(:copy_access_value) { document.copy_access_urls }

      it "generates links to the online copy" do
        expect(copy_access_value).to eq [{href: "http://nla.gov.au/nla.arc-139469", text: "Archived at ANL (2012-2016)"}]
      end
    end
  end

  describe "#copyright_info" do
    context "when there is copyright information" do
      subject(:copyright_info_value) do
        document = described_class.new(
          marc_ss: copyright_info,
          copyright_ssim: ["© The State of Queensland (Department of the Premier and Cabinet) 2012."]
        )
        document.copyright_info
      end

      it "returns the copyright information" do
        expect(copyright_info_value).to eq ["© The State of Queensland (Department of the Premier and Cabinet) 2012."]
      end
    end

    context "when there is no copyright information" do
      subject(:copyright_info_value) do
        document = described_class.new(marc_ss: publication_date)
        document.copyright_info
      end

      it "returns nil" do
        expect(copyright_info_value).to eq []
      end
    end
  end

  describe "#copyright_status" do
    subject(:copyright_status) do
      document.copyright_status
    end

    let(:document) { described_class.new(marc_ss: form_of_work, id: 7291584) }

    it "will return the copyright information for the work" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))

      WebMock.stub_request(:get, "https://example.com/copyright/")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: IO.read("spec/files/copyright/service_response.xml").to_s, headers: {})

      expect(copyright_status).not_to be_nil
      expect(copyright_status["contextMsg"]).to eq "1.1"
    end

    context "when no copyright info is returned by the SOA" do
      it "will return nil" do
        stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))

        WebMock.stub_request(:get, "https://example.com/copyright/")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 502, body: "", headers: {})

        expect(copyright_status).to be_nil
      end
    end
  end

  describe "#credits" do
    context "when there are credits" do
      subject(:credits_value) do
        document = described_class.new(
          marc_ss: credits,
          credits_tsim: ["Edited by C.R.J. Currie, <1995>-",
            "Edited by A. J. Fletcher, <2002>-"]
        )
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

      it "will return nil" do
        expect(credits_value).to eq []
      end
    end
  end

  describe "#data_quality" do
    context "when there are data quality information" do
      subject(:data_quality_value) do
        document = described_class.new(
          marc_ss: data_quality,
          data_quality_tsim: ["Last copy of this item within Australia."]
        )
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

      it "will return nil" do
        expect(data_quality_value).to eq []
      end
    end
  end

  describe "#description" do
    subject(:description_value) do
      document = described_class.new(
        marc_ss: single_series,
        description_tsim: ["x, 197 p. : ill. ; 26 cm."],
        description_date_tsim: ["Shatin, N. T., Hong Kong : Institute of Chinese Studies, Chinese University of Hong Kong, c1985."]
      )
      document.description
    end

    it "retrieves the description from the MARC record" do
      expect(description_value).to eq ["Shatin, N. T., Hong Kong : Institute of Chinese Studies, Chinese University of Hong Kong, c1985", "x, 197 p. : ill. ; 26 cm."]
    end
  end

  describe "#edition" do
    context "when there is an edition in subfield 250" do
      subject(:edition_value) do
        document = described_class.new(
          marc_ss: edition,
          edition_tsim: ["3d ed."]
        )
        document.edition
      end

      it "will return the edition" do
        expect(edition_value).to eq ["3d ed."]
      end
    end

    context "when there is an edition in subfield 880 and subfield 250" do
      subject(:edition_value) do
        document = described_class.new(
          marc_ss: edition_880,
          edition_tsim: ["Chu ban.", "初版."]
        )
        document.edition
      end

      it "will return both editions" do
        expect(edition_value).to eq ["Chu ban.", "初版."]
      end

      it "will return the 880 value first" do
        expect(edition_value.first).to eq "Chu ban."
      end
    end
  end

  describe "#exhibited" do
    context "when there are exhibitions" do
      subject(:exhibited_value) do
        document = described_class.new(
          marc_ss: exhibition_info,
          exhibited_tsim: ["Exhibited: Abstraction-Creation: J.W. Power in Europe 1921-1938, Heide Museum of Modern Art, 15 November 2014- early March 2015",
            "Exhibited: \"Treasures Gallery\", National Library of Australia, 7 October 2011 - 15 December 2012.",
            "S6634 Pierrot et Arlequin exhibited: Treasures Gallery 2010: A Preview, National Library of Australia, Canberra, 22 April - 19 July 2009."]
        )
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

      it "will return nil" do
        expect(exhibited_value).to eq []
      end
    end
  end

  describe "#full_contents" do
    context "when there is a contents list" do
      subject(:full_contents_value) do
        document = described_class.new(
          marc_ss: full_contents,
          full_contents_tsim: ["Foreword / Bill Maher -- Introduction: Spinning This Book -- 1. The Possible Light -- Spin Hall of Fame: Robert D. Novak on Al Gore -- Spin Hall of Fame: Kate O'Beirne on Hillary Clinton -- 2. It Didn't Start with Clinton -- Spin Hall of Fame: Cal Thomas on Satan -- 3. All the Spin That's Fit to Print -- 4. Politics: Slippery Not Only When Wet -- Spin Hall of Fame: Margaret Carlson on Max Kennedy -- Spin Hall of Fame: Hendrik Hertzberg on Jimmy Carter -- 5. Clinton: The Man Who Broke the Spinning Wheel -- Spin Hall of Fame: Tony Blankley on Lanny Davis -- 6. Campaign 2000: The Spin Derby -- Spin Hall of Fame: Paul Begala on George W. Bush -- Spin Hall of Fame: Oliver North on Al Gore -- Spin Hall of Fame: Al Franken on Karl Rove -- 7. President Bush: New Spinner in the White House -- 8. Spinning the Legal System -- 9. Spinning to Sell a Product -- 10. Everyday People, Everyday Spin -- Spin Hall of Fame: Tucker Carlson on Joe Carollo.",
            "Spin Hall of Fame: Mary Matalin on James Carville -- 11. Sex and Dating: Where Spin Begins ... and Ends -- 12. Closing Comments."]
        )
        document.full_contents
      end

      it "will return the list of contents" do
        expect(full_contents_value.size).to(eq(2))
      end
    end
  end

  describe "#form_of_work" do
    context "when there is a form of work" do
      subject(:form_of_work_value) do
        document = described_class.new(
          marc_ss: form_of_work,
          form_of_work_tsim: ["Interviews"]
        )
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

  describe "#frequency" do
    context "when there are frequencies" do
      subject(:frequency_value) do
        document = described_class.new(
          marc_ss: frequency,
          frequency_tsim: ["Yue kan", "月刊"]
        )
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

      it "will return nil" do
        expect(frequency_value).to eq []
      end
    end
  end

  describe "#genre" do
    context "when there are forms/genres" do
      subject(:genre_value) do
        document = described_class.new(
          marc_ss: genre,
          genre_tsim: ["Guides, General", "Opinion Papers", "Tests/Questionnaires"]
        )
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

      it "will return nil" do
        expect(genre_value).to eq []
      end
    end
  end

  describe "#govt_doc_number" do
    context "when there are government document numbers" do
      subject(:govt_doc_number_value) do
        document = described_class.new(
          marc_ss: govt_doc_number,
          govt_doc_number_tsim: ["C 55.287/50:", "C 55.286/6-49:"]
        )
        document.govt_doc_number
      end

      it "will return all the government document numbers" do
        expect(govt_doc_number_value.size).to eq 2
        expect(govt_doc_number_value).to include "C 55.287/50:"
      end
    end

    context "when there are no government document numbers" do
      subject(:govt_doc_number_value) do
        document = described_class.new(marc_ss: provenance)
        document.govt_doc_number
      end

      it "will return nil" do
        expect(govt_doc_number_value).to eq []
      end
    end
  end

  describe "#has_subseries" do
    context "when there are subseries" do
      subject(:has_subseries_value) do
        document = described_class.new(
          marc_ss: has_subseries_info,
          has_subseries_tsim: ["20th century art",
            "19th century art",
            "18th century art",
            "17th century art",
            "16th century art",
            "Primitive art"]
        )
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

      it "will return nil" do
        expect(has_subseries_value).to eq []
      end
    end
  end

  describe "#has_supplement" do
    context "when there are supplements" do
      subject(:supplement_value) do
        document = described_class.new(
          marc_ss: has_supplement,
          has_supplement_tsim: ["Forest products market trends in ... and prospects for ...",
            "Annual forest products market review",
            "Monthly prices for forest products",
            "United Nations. Economic Commission for Europe. Timber Committee. ECE Timber Committee yearbook"]
        )
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

      it "will return nil" do
        expect(supplement_value).to eq []
      end
    end
  end

  describe "#incomplete_contents" do
    context "when there are incomplete contents" do
      subject(:incomplete_contents_value) do
        document = described_class.new(
          marc_ss: incomplete_contents,
          incomplete_contents_tsim: ["FDI trends and performance -- The investment framework -- The role of FDI for SME development -- Conclusion and recommendations."]
        )
        document.incomplete_contents
      end

      it "will return all the incomplete contents" do
        expect(incomplete_contents_value.size).to eq 1
      end
    end

    context "when there are no incomplete contents" do
      subject(:incomplete_contents_value) do
        document = described_class.new(marc_ss: full_contents)
        document.incomplete_contents
      end

      it "will return nil" do
        expect(incomplete_contents_value).to eq []
      end
    end
  end

  describe "#index_finding_aid_note" do
    context "when there are finding aid notes" do
      subject(:index_finding_aid_note_value) do
        document = described_class.new(
          marc_ss: index_finding_aid_note,
          index_finding_aid_note_tsim: ["General index: Vols. 1 (1847)-10 (1856), in v. 10 (Includes index to the journal under its earliest title).",
            "Person index: Vols. 1 (1847)-50 (1896).  3 v. (Includes index to the journal under its earlier and later titles).",
            "Subject index: Vols. 1 (1847)-50 (1896).  1 v. (Includes index to the journal under its earlier and later titles).",
            "Place index: Vols. 1 (1847)-41 (1887), in v. 42; v. 1 (1847)-50 (1896).  1 v. (Includes index to the journal under its earlier and later titles).",
            "Genealogical and pedigree index: Vols. 1 (1847)-50 (1896), in v. 50. (Includes index to the journal under its earlier and later titles)."]
        )
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

      it "will return nil" do
        expect(index_finding_aid_note_value).to eq []
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

      it "will return nil" do
        expect(invalid_isbn_value).to be_nil
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

  describe "#invalid_ismn" do
    context "when there is an ISMN" do
      subject(:invalid_ismn_value) do
        document = described_class.new(
          marc_ss: invalid_ismn,
          invalid_ismn_ssim: ["M720067568 M72005967568"],
          ismn_ssim: ["9790720067568"]
        )
        document.invalid_ismn
      end

      it "will return the invalid ISMN" do
        expect(invalid_ismn_value).to eq %w[M720067568 M72005967568]
      end
    end

    context "when there are multiple ISMNs" do
      subject(:invalid_ismn_value) do
        document = described_class.new(
          marc_ss: invalid_ismn,
          invalid_ismn_ssim: ["M720067568 M72005967568"]
        )
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

      it "will return nil" do
        expect(invalid_ismn_value).to be_nil
      end
    end
  end

  describe "#invalid_issn" do
    context "when there is an invalid ISSN" do
      subject(:invalid_issn_value) do
        document = described_class.new(
          marc_ss: invalid_issn,
          invalid_issn_ssim: %w[0318-2606 0844-837X]
        )
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

      it "will return nil" do
        expect(invalid_issn_value).to eq []
      end
    end
  end

  describe "#isbn" do
    context "when there is an ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn)
        document.valid_isbn
      end

      it "will return the ISBN" do
        expect(isbn_value).to eq ["0855507322 (corrected)", "0855507403", "1111 (dummy)"]
      end
    end

    context "when there is a linked 880" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn)
        document.valid_isbn
      end

      it "will return the ISBN" do
        expect(isbn_value).to include "1111 (dummy)"
      end
    end

    context "when there are more than one ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: multiple_isbn)
        document.valid_isbn
      end

      it "will return all the ISBN" do
        expect(isbn_value).to eq ["0855507322 (corrected)", "0855507403", "1111 (dummy)"]
      end
    end

    context "when there is a qualifier" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: multiple_isbn)
        document.valid_isbn
      end

      it "will append it after the ISBN" do
        expect(isbn_value.first).to include " (corrected)"
      end
    end

    context "when there is no ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: invalid_issn)
        document.valid_isbn
      end

      it "will return nil" do
        expect(isbn_value).to be_nil
      end
    end

    context "when there is extra punctuation around the ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn_format)
        document.valid_isbn
      end

      it "will strip extra punctuation around the ISBN" do
        expect(isbn_value).to eq ["9781478007364 (electronic book)", "1478007362 (electronic book)"]
      end
    end
  end

  describe "#isbn_list" do
    context "when there is an ISBN" do
      subject(:isbn_value) do
        document = described_class.new(marc_ss: isbn, isbn_tsim: ["9781740457590 :", "1740457595", "9781740457590"])
        document.isbn_list
      end

      it "will return the ISBNs as numbers only" do
        expect(isbn_value).to eq %w[9781740457590 1740457595 9781740457590]
      end
    end
  end

  describe "#ismn" do
    context "when there is an ISMN" do
      subject(:ismn_value) do
        document = described_class.new(
          marc_ss: ismn,
          ismn_ssim: ["9790720160313"]
        )
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

      it "will return nil" do
        expect(ismn_value).to be_nil
      end
    end
  end

  describe "#issn" do
    context "when there is an ISSN" do
      subject(:issn_value) do
        document = described_class.new(
          marc_ss: issn,
          issn_display_ssim: ["0000-0442"]
        )
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

      it "will return nil" do
        expect(invalid_issn_value).to eq []
      end
    end
  end

  describe "#issued_with" do
    context "when there are related issues" do
      subject(:issued_with_value) do
        document = described_class.new(
          marc_ss: issued_with,
          issued_with_tsim: ["United States. Federal Labor Relations Authority. Administrative law judge decisions report 0742-616X",
            "United States. Federal Labor Relations Authority. Report of case decisions x 0147-3611"]
        )
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

      it "will return nil" do
        expect(issued_with_value).to eq []
      end
    end
  end

  describe "#lccn" do
    context "when there is an lccn" do
      subject(:lccn_value) do
        document = described_class.new(
          marc_ss: isbn_format,
          lccn_ssim: ["  2019016276"]
        )
        document.lccn
      end

      it "returns the lccn as numbers only" do
        expect(lccn_value).to eq ["2019016276"]
      end
    end
  end

  describe "#life_dates" do
    context "when there is a single life date" do
      subject(:life_dates_value) do
        document = described_class.new(
          marc_ss: single_life_date,
          life_dates_tsim: ["-84. Jagrg., Heft 6 (Dez. 1974)"]
        )
        document.life_dates
      end

      it "will return the life date" do
        expect(life_dates_value).to eq ["-84. Jagrg., Heft 6 (Dez. 1974)"]
      end
    end

    context "when there are multiple life dates" do
      subject(:life_dates_value) do
        document = described_class.new(
          marc_ss: multiple_life_dates,
          life_dates_tsim: ["Began in Jan. 6, 1966", "-v. 13, no. 13 (Apr. 5, 1978)"]
        )
        document.life_dates
      end

      it "will return the life dates" do
        expect(life_dates_value.size).to eq 2
      end
    end
  end

  describe "#map_search" do
    context "when map search service can't be reached" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: map_search, id: 113030, format: "Map")
        document.map_search_urls
      end

      it "does not generate a link to Map Search" do
        stub_request(:get, "https://mapsearch.nla.gov.au/search/search?type=map&text=113030")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_raise(StandardError)

        expect(map_search_value).to be_nil
      end
    end

    context "when there is a record in Map Search" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: map_search, id: 113030, format: "Map")
        document.map_search_urls
      end

      let(:mock_response) { IO.read("spec/files/map_search/113030.json") }

      it "generates a link to Map Search" do
        stub_request(:get, "https://mapsearch.nla.gov.au/search/search?type=map&text=113030")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: mock_response, headers: {})

        expect(map_search_value).to eq ["https://mapsearch.nla.gov.au?type=map&mapClassifications=all&geolocation=all&text=113030"]
      end
    end

    context "when there is no record in Map Search" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: no_map_search, id: 3647081, format: "Map")
        document.map_search_urls
      end

      let(:mock_response) { IO.read("spec/files/map_search/3647081.json") }

      it "does not generate a link to Map Search" do
        stub_request(:get, "https://mapsearch.nla.gov.au/search/search?type=map&text=3647081")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: mock_response, headers: {})

        expect(map_search_value).to be_nil
      end
    end

    context "when there is no 'format'" do
      subject(:map_search_value) do
        document = described_class.new(marc_ss: no_format)
        document.map_search_urls
      end

      it "does not generate a link to Map Search" do
        expect(map_search_value).to be_nil
      end
    end
  end

  describe "#music_publisher_number" do
    context "when there are music publisher numbers" do
      subject(:music_publisher_number_value) do
        document = described_class.new(
          marc_ss: music_publisher_number,
          music_publisher_number_tsim: ["A.C. 1483", "A.C. 8097", "22805"]
        )
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

      it "will return nil" do
        expect(music_publisher_number_value).to eq []
      end
    end
  end

  describe "#new_title" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(
          marc_ss: later_title,
          new_title_tsim: ["Presbyterian Church of New Zealand. Year book - Presbyterian Church of New Zealand 0551-9853",
            "Presbyterian Church of New Zealand. General Assembly. Year book and proceedings of the Presbyterian Church of New Zealand 0110-0416"]
        )
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

      it "will return nil" do
        expect(title_value).to eq []
      end
    end
  end

  describe "#notes" do
    context "when there is a single note" do
      subject(:notes_value) do
        document = described_class.new(
          marc_ss: single_note,
          notes_tsim: ["May also be available online. Address as at 14/8/18: https://eric.ed.gov/"]
        )
        document.notes
      end

      it "retrieves the note" do
        expect(notes_value).to eq(["May also be available online. Address as at 14/8/18: https://eric.ed.gov/"])
      end
    end

    context "when there are multiple notes" do
      subject(:notes_value) do
        document = described_class.new(
          marc_ss: multiple_notes,
          notes_tsim: ["Originally produced as a motion picture in 1965.",
            "Single-sided single layer; aspect ratio 16:9.",
            "Title from disc label.",
            "Based on the work Nippon military march by Dan Ikuma.",
            "Based on the work Nippon military march by 團伊玖磨."]
        )
        document.notes
      end

      it "fetches non-880 and 880 notes" do
        expect(notes_value).to eq([
          "Originally produced as a motion picture in 1965.",
          "Single-sided single layer; aspect ratio 16:9.",
          "Title from disc label.",
          "Based on the work Nippon military march by Dan Ikuma.",
          "Based on the work Nippon military march by 團伊玖磨."
        ])
      end
    end

    context "when there are no notes" do
      subject(:notes_value) do
        document = described_class.new(marc_ss: no_notes)
        document.notes
      end

      it "will return nil" do
        expect(notes_value).to eq []
      end
    end
  end

  describe "#numbering_note" do
    context "when there are numbering notes" do
      subject(:numbering_note_value) do
        document = described_class.new(
          marc_ss: numbering_note,
          numbering_note_tsim: ["Issues for 1984-1988 designated by vol. and no. and year.",
            "Issue numbering for v. 198 (1984) rotates among the four parts, e.g., Part B includes no. 2, 6, 10, 14.",
            "Issues for v. 199 (1985)-202 (1988) designated no. B1-B4 within each volume."]
        )
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

      it "will return nil" do
        expect(numbering_note_value).to eq []
      end
    end
  end

  describe "#old_title" do
    context "when there are titles" do
      subject(:title_value) do
        document = described_class.new(
          marc_ss: former_title,
          old_title_tsim: ["General business and agricultural conditions 1917-20",
            "Agricultural and business conditions in the Twelfth Federal Reserve District 1921-22",
            "Monthly review of business conditions 1923-Jan. 1937",
            "Monthly review, business conditions in the Twelfth Federal Reserve District Mar. 1937-1941"]
        )
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

      it "will return nil" do
        expect(title_value).to eq []
      end
    end
  end

  describe "#online_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there is an online resource" do
      subject(:online_access_value) do
        document.online_access_urls
      end

      it "generates links to the online resources" do
        expect(online_access_value).to eq [{href: "https://nla.gov.au/nla.obj-600301366", text: "National edeposit"},
          {href: "http://epress.anu.edu.au/AH33_citation.html", text: "http://epress.anu.edu.au/AH33_citation.html"},
          {href: "http://epress.anu.edu.au/titles/aboriginal-history-journal", text: "Publisher site"}]
      end
    end

    context "when there is a colon at the end of the link title" do
      subject(:online_access_value) do
        document.online_access_urls
      end

      let(:document) { described_class.new(marc_ss: online_access_with_colon) }

      it "removes the colon" do
        expect(online_access_value.first[:text]).not_to include(":")
      end
    end
  end

  describe "#other_authors" do
    context "when there are other authors" do
      additional_author_with_relator_ssim = [
        "New South Wales. Board of Surveying and Spatial Information. Annual report",
        "New South Wales. Board of Surveying and Spatial Information",
        "Land and Property Management Authority (N.S.W.)"
      ]
      author_ssim = ["New South Wales. Department of Lands"]

      subject(:other_authors_value) do
        document = described_class.new(
          marc_ss: other_authors,
          author_ssim: author_ssim,
          additional_author_with_relator_ssim: additional_author_with_relator_ssim
        )
        document.other_authors
      end

      it "will return other authors" do
        expect(other_authors_value.size).to eq 3
      end
    end

    context "when there are related 880 other authors" do
      additional_author_with_relator_ssim = [
        "Suwit Thatphithakkun, 1928-2015, honouree",
        "สุวิทย์ ทัดพิทักษ์กุล, 1928-2015, honouree"
      ]
      author_addl_ssim = [
        "Suwit Thatphithakkun, 1928-2015",
        "สุวิทย์ ทัดพิทักษ์กุล, 1928-2015"
      ]

      subject(:other_authors_value) do
        document = described_class.new(
          marc_ss: terms_of_service,
          author_addl_ssim: author_addl_ssim,
          additional_author_with_relator_ssim: additional_author_with_relator_ssim
        )
        document.other_authors
      end

      it "will return related other authors" do
        expect(other_authors_value).to include("สุวิทย์ ทัดพิทักษ์กุล, 1928-2015, honouree")
      end
    end

    context "when there are no terms of use" do
      subject(:other_authors_value) do
        document = described_class.new(marc_ss: terms_of_service)
        document.other_authors
      end

      it "will return nil" do
        expect(other_authors_value).to eq []
      end
    end
  end

  describe "#partial_contents" do
    context "when there are partial contents" do
      subject(:partial_contents_value) do
        document = described_class.new(
          marc_ss: partial_contents,
          partial_contents_tsim: ["Opening of the workshop -- Background and international framework for port state measures -- Bilateral, subregional and regional approaches to IUU fishing and port state measures -- Issues and framework of the 2005 model scheme on port state measures and the 2009 chairperson's original draft agreement on port state measures -- National coordination and implementation of port state measures : pilot projects and current strengths and constraints -- Legal and regional perspectives on port state measures -- Formation of the working groups and their reports and conclusions -- Brainstorming : looking ahead : an agenda for the subregion on port state measures -- Closure of the workshop."]
        )
        document.partial_contents
      end

      it "will render the full list of contents" do
        expect(partial_contents_value.size).to eq 1
      end
    end

    context "when there are no partial contents" do
      subject(:partial_contents_value) do
        document = described_class.new(marc_ss: full_contents)
        document.partial_contents
      end

      it "will return nil" do
        expect(partial_contents_value).to eq []
      end
    end
  end

  describe "#performers" do
    context "when there are performers" do
      subject(:performers_value) do
        document = described_class.new(
          marc_ss: performers,
          performers_tsim: ["Keith Bowen.", "Jeremy Ashton.", "Carol Shelbourn."]
        )
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

      it "will return nil" do
        expect(performers_value).to eq []
      end
    end
  end

  describe "#place" do
    context "when there are places" do
      subject(:place_value) do
        document = described_class.new(
          marc_ss: place,
          place_tsim: ["United States Pennsylvania Philadelphia.",
            "United States Massachusetts Boston."]
        )
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

      it "will return nil" do
        expect(place_value).to eq []
      end
    end
  end

  describe "#previous_frequency" do
    context "when there are previous frequencies" do
      subject(:previous_frequency_value) do
        document = described_class.new(
          marc_ss: previous_frequency,
          previous_frequency_tsim: ["Xun kan", "旬刊"]
        )
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

      it "will return nil" do
        expect(previous_frequency_value).to eq []
      end
    end
  end

  describe "#printer" do
    context "when the 260 field has a printer" do
      subject(:printer_value) do
        document = described_class.new(
          marc_ss: printer_260,
          printer_tsim: ["(Adelaide : Specialty Printers)"]
        )
        document.printer
      end

      it "will return the printer text" do
        expect(printer_value).to include "(Adelaide : Specialty Printers)"
      end
    end

    context "when the 264 field has a printer" do
      subject(:printer_value) do
        document = described_class.new(
          marc_ss: printer_264,
          printer_tsim: ["Melbourne : C. Troedel, approximately 1863."]
        )
        document.printer
      end

      it "will return nil" do
        expect(printer_value).to include "Melbourne : C. Troedel, approximately 1863."
      end
    end

    context "when the 264 field does not have an indicator2 value of 3" do
      subject(:printer_value) do
        document = described_class.new(marc_ss: no_printer_264)
        document.printer
      end

      it "will return nil" do
        expect(printer_value).to eq []
      end
    end
  end

  describe "#provenance" do
    context "when 541 field has provenance" do
      subject(:provenance_value) do
        document = described_class.new(
          marc_ss: provenance,
          provenance_tsim: ["National Library of Australia's copy is from the Jack Greaves Collection."]
        )
        document.provenance
      end

      it "will return all the provenance information" do
        expect(provenance_value).to include "National Library of Australia's copy is from the Jack Greaves Collection."
      end
    end

    context "when 561 field has provenance" do
      subject(:provenance_value) do
        document = described_class.new(
          marc_ss: provenance_561,
          provenance_tsim: ["Franklin Collection."]
        )
        document.provenance
      end

      it "will return all the provenance information" do
        expect(provenance_value).to include "Franklin Collection."
      end
    end

    context "when there is no provenance" do
      subject(:provenance_value) do
        document = described_class.new(marc_ss: binding_information)
        document.provenance
      end

      it "will return nil" do
        expect(provenance_value).to eq []
      end
    end
  end

  describe "#publication_date" do
    context "when publication date" do
      subject(:publication_date_value) do
        document = described_class.new(
          marc_ss: publication_date,
          display_publication_date_ssim: ["[1976] c1975"]
        )
        document.publication_date
      end

      it "returns the publication date" do
        expect(publication_date_value).to eq ["[1976] c1975"]
        expect(publication_date_value.size).to eq 1
      end
    end

    context "when alternate publication date" do
      subject(:publication_date_value) do
        document = described_class.new(
          marc_ss: alternate_publication_date,
          display_publication_date_ssim: ["2012"]
        )
        document.publication_date
      end

      it "returns the alternate publication date" do
        expect(publication_date_value).to eq ["2012"]
        expect(publication_date_value.size).to eq 1
      end
    end
  end

  describe "#related_access" do
    let(:document) { described_class.new(marc_ss: online_access) }

    context "when there are related resources" do
      subject(:related_access_value) { document.related_access_urls }

      it "generates links to the related resources" do
        expect(related_access_value).to eq [{href: "https://nla.gov.au/nla.obj-600301366-t", text: "Thumbnail"}]
      end
    end
  end

  describe "#related_material" do
    context "when there is related material" do
      subject(:related_material_value) do
        document = described_class.new(
          marc_ss: related_material,
          related_material_tsim: ["Interview with Dr John Burton, diplomat; Located at; National Library of Australia Oral History collection ORAL TRC 2981/23.",
            "Interview with Dr. John Wear Burton; Located at; National Library of Australia Oral History collection ORAL TRC 3958.",
            "John Burton interviewed by Richard Rubenstein and Christopher Mitchell; Located at; National Library of Australia Oral History collection ORAL TRC 4665.",
            "Cecily Parker, psychotherapist, interviewed by Meredith Edwards; Located at; National Library of Australia Oral History collection ORAL TRC 5094.",
            "Pamela Burton interviewed by Kim Rubenstein in the Trailblazing women and the law oral history project; Located at; National Library of Australia Oral History collection ORAL TRC 6535/11."]
        )
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

      it "will return nil" do
        expect(related_material_value).to eq []
      end
    end
  end

  describe "#related_title" do
    context "when there are related titles" do
      subject(:related_title_value) do
        document = described_class.new(
          marc_ss: related_title,
          related_title_tsim: ["Keizai hakusho", "経済白書."]
        )
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

      it "will return nil" do
        expect(related_title_value).to eq []
      end
    end
  end

  describe "#reproduction" do
    context "when there are reproductions" do
      subject(:reproduction_value) do
        document = described_class.new(
          marc_ss: reproductions,
          reproduction_tsim: ["Photo-offset. Xianggang?, 1970?. 19 cm.",
            "Photo-offset. 香港?, 1970?. 19 cm."]
        )
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

      it "will return nil" do
        expect(reproduction_value).to eq []
      end
    end
  end

  describe "#scale" do
    context "when there is scale" do
      subject(:scale_value) do
        document = described_class.new(
          marc_ss: scale,
          scale_tsim: ["Scale [1:31,680]. Two inches to a mile (E 145°20'--E 145°45'/S 38°15'--S 38°30')"]
        )
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

      it "will return nil" do
        expect(scale_value).to eq []
      end
    end
  end

  describe "#series" do
    context "when there is a single series" do
      subject(:series_value) do
        document = described_class.new(
          marc_ss: single_series,
          series_tsim: ["International Symposium on Sino-Japanese Cultural Interchange (1979 : Chinese University of Hong Kong). Papers ; v. 1."]
        )
        document.series
      end

      it "retrieves the series from the MARC record" do
        expect(series_value).to eq ["International Symposium on Sino-Japanese Cultural Interchange (1979 : Chinese University of Hong Kong). Papers ; v. 1."]
      end
    end

    context "when there are multiple series" do
      subject(:series_value) do
        document = described_class.new(
          marc_ss: multiple_series,
          series_tsim: ["Australian National Audit Office. Audit report ; 2005-2006, no. 16",
            "Australian National Audit Office. Performance report",
            "Auditor-General audit report ; no. 16, 2005-2006",
            "Performance audit / Australian National Audit Office",
            "Parliamentary paper (Australia. Parliament) ; 2005, no. 434."]
        )
        document.series
      end

      it "retrieves all the series entries from the MARC record" do
        expect(series_value.size).to eq 5
      end
    end
  end

  describe "#subseries_of" do
    context "when there are series" do
      subject(:subseries_of_value) do
        document = described_class.new(
          marc_ss: subseries_of_info,
          subseries_of_tsim: ["DHHS publication", "DHEW publication"]
        )
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

      it "will return nil" do
        expect(subseries_of_value).to eq []
      end
    end
  end

  describe "#summary" do
    context "when there are summaries" do
      subject(:summary_value) do
        document = described_class.new(
          marc_ss: summary,
          summary_tsim: ["Past attempts to answer this question have ranged widelyfrom less than 1 billion to more than 1,000 billion - one sign that there is no single right answer. More than half of the estimates, however, fall within a much narrower range: between 4 billion and 16 billion. In any case, with the world population now at 5.7 billion, and increasing by approximately 90 million per year, we have clearly entered a zone where limits on the human carrying capacity of the Earth have been anticipated, and may well be encountered.",
            "In this penetrating analysis of one of the most crucial questions of our time, a leading scholar in the field reviews the history of world population growth and gives a refreshingly frank appraisal of what little can be known about its future. In the process, he offers the most comprehensive account yet available of how various people have tried to estimate the planet's human carrying capacity. Few contemporary writers have addressed the issue of world population growth in such a balanced, objective way, without using it as a pretext to advance a prior political agenda."]
        )
        document.summary
      end

      it "will return an array of summaries" do
        expect(summary_value.size).to eq 2
      end
    end

    context "when there are summaries in linked 880 fields" do
      subject(:summary_value) do
        document = described_class.new(
          marc_ss: summary_880,
          summary_tsim: ["Xiu ci ge ji ji ji xiu ci de ge zhong ge shi. Gong 5 zhang. Jiang shu gen yu bi jiao de xiu ci ge, gen yu lian xiang de xiu ci ge, gen yu xiang xiang de xiu ci ge, gen yu qu zhe de xiu ci ge, gen yu chong fu de xiu ci ge deng 5 zhong xiu ci ge shi.",
            "修辭格即積極修辭的各種格式. 共5章. 講述根於比較的修辭格、根於聯想的修辭格、根於想象的修辭格、根於曲折的修辭格、根於重複的修辭格等5種修辭格式."]
        )
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

      it "will return nil" do
        expect(summary_value).to eq []
      end
    end
  end

  describe "#supplement_to" do
    context "when there are supplements" do
      subject(:supplement_value) do
        document = described_class.new(
          marc_ss: supplement_to,
          supplement_to_tsim: ["ANZIAM journal 1446-1811", "Anziam journal (Online) 1446-8735"]
        )
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

      it "will return nil" do
        expect(supplement_value).to eq []
      end
    end
  end

  describe "#technical_details" do
    context "when there are technical details" do
      subject(:technical_details_value) do
        document = described_class.new(
          marc_ss: technical_details,
          technical_details_tsim: ["Mode of access: Available online. Address as at 25/08/14: http://www.coagreformcouncil.gov.au/reports/housing.html"]
        )
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

      it "will return nil" do
        expect(technical_details_value).to eq []
      end
    end
  end

  describe "#terms_of_use" do
    context "when there are terms of use" do
      subject(:terms_value) do
        document = described_class.new(
          marc_ss: terms_of_service,
          terms_of_use_tsim: ["Copyright A.P.R.A. 1999.", "Copyright A.P.R.A. 1997.", "Copyright A.P.R.A. 1998."]
        )
        document.terms_of_use
      end

      it "will return the terms of use" do
        expect(terms_value.size).to eq 3
      end
    end

    context "when there are no terms of use" do
      subject(:terms_value) do
        document = described_class.new(marc_ss: place)
        document.terms_of_use
      end

      it "will return nil" do
        expect(terms_value).to eq []
      end
    end
  end

  describe "#time_coverage" do
    context "when single time coverage" do
      subject(:time_coverage_value) do
        document = described_class.new(
          marc_ss: single_time_coverage,
          time_coverage_single_ssim: ["d1916"]
        )
        document.time_coverage
      end

      it "returns a single year" do
        expect(time_coverage_value).to eq ["1916"]
      end
    end

    context "when there are mulitple time coverages" do
      subject(:time_coverage_value) do
        document = described_class.new(
          marc_ss: multiple_time_coverage,
          time_coverage_multiple_ssim: %w[d1868 d1880]
        )
        document.time_coverage
      end

      it "returns comma separated years" do
        expect(time_coverage_value).to eq ["1868, 1880"]
      end
    end

    context "when there is a range of time coverage" do
      subject(:time_coverage_value) do
        document = described_class.new(
          marc_ss: ranged_time_coverage,
          time_coverage_range_ssim: %w[d1890 d1899]
        )
        document.time_coverage
      end

      it "returns a range of years" do
        expect(time_coverage_value).to eq ["1890-1899"]
      end
    end

    context "when the year is too long" do
      subject(:time_coverage_value) do
        document = described_class.new(
          marc_ss: year_too_long_time_coverage,
          time_coverage_single_ssim: ["d192112"]
        )
        document.time_coverage
      end

      it "returns the year with only 4 digits" do
        expect(time_coverage_value).to eq ["1921"]
      end
    end
  end

  describe "#translated_title" do
    context "when there are translated titles" do
      subject(:translated_title_value) do
        document = described_class.new(
          marc_ss: translated_title,
          translated_title_ssim: ["Promoting a Healthy Future [microform] : Training Manual for Health Educators and Instructors Who Work with Young Health Promoters, Young Counselors or Educators and Volunteers / Carmen Duran and Paloma Cuchi."]
        )
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

      it "will return nil" do
        expect(translated_title_value).to eq []
      end
    end
  end

  describe "#uniform_title" do
    context "when there is a uniform title in subfield 130" do
      subject(:uniform_title_value) do
        document = described_class.new(
          marc_ss: uniform_title_130,
          uniform_title_ssim: ["Wort Hesed. English"]
        )
        document.uniform_title
      end

      it "will display the uniform title" do
        expect(uniform_title_value).to eq ["Wort Hesed. English"]
      end
    end

    context "when there is a uniform title in subfield 240" do
      subject(:uniform_title_value) do
        document = described_class.new(
          marc_ss: uniform_title_240,
          uniform_title_ssim: ["De foto's van Jongensjaren. Spanish"]
        )
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

      it "will return nil" do
        expect(uniform_title_value).to eq []
      end
    end
  end

  private

  def access_condition
    load_marc_from_file 3926789
  end

  def access_condition_with_eresources
    load_marc_from_file 3755597
  end

  def acknowledgements
    load_marc_from_file 4464657
  end

  def also_titled
    load_marc_from_file 4327251
  end

  def alternate_publication_date
    load_marc_from_file 5976915
  end

  def available_from
    load_marc_from_file 23706
  end

  def awards
    load_marc_from_file 7328922
  end

  def binding_information
    load_marc_from_file 5744995
  end

  def biography_history
    load_marc_from_file 5497731
  end

  def biography_history_with_url
    load_marc_from_file 1856161
  end

  def cited_in
    load_marc_from_file 5784759
  end

  def copyright_info
    load_marc_from_file 8413658
  end

  def credits
    load_marc_from_file 778088
  end

  def data_quality
    load_marc_from_file 8539536
  end

  def edition
    load_marc_from_file 1336868
  end

  def edition_880
    load_marc_from_file 6290058
  end

  def exhibition_info
    load_marc_from_file 6453708
  end

  def form_of_work
    load_marc_from_file 7291584
  end

  def former_title
    load_marc_from_file 2181169
  end

  def frequency
    load_marc_from_file 4604577
  end

  def full_contents
    load_marc_from_file 1455669
  end

  def genre
    load_marc_from_file 5474602
  end

  def govt_doc_number
    load_marc_from_file 3823089
  end

  def has_subseries_info
    load_marc_from_file 2036712
  end

  def has_supplement
    load_marc_from_file 1125877
  end

  def incomplete_contents
    load_marc_from_file 4864988
  end

  def index_finding_aid_note
    load_marc_from_file 773963
  end

  def invalid_isbn
    load_marc_from_file 1868021
  end

  def invalid_ismn
    load_marc_from_file 4773335
  end

  def invalid_issn
    load_marc_from_file 3022824
  end

  def isbn
    load_marc_from_file 1868021
  end

  def isbn_format
    load_marc_from_file 8420291
  end

  def ismn
    load_marc_from_file 8665709
  end

  def issn
    load_marc_from_file 28336
  end

  def issued_with
    load_marc_from_file 1475436
  end

  def later_title
    load_marc_from_file 2142448
  end

  def map_search
    load_marc_from_file 113030
  end

  def multiple_isbn
    load_marc_from_file 1868021
  end

  def multiple_life_dates
    load_marc_from_file 1324307
  end

  def multiple_notes
    load_marc_from_file 8174421
  end

  def multiple_series
    load_marc_from_file 8126677
  end

  def multiple_time_coverage
    load_marc_from_file 568776
  end

  def music_publisher_number
    load_marc_from_file 3356244
  end

  def no_format
    load_marc_from_file 7251259
  end

  def no_map_search
    load_marc_from_file 3647081
  end

  def no_notes
    load_marc_from_file 3079596
  end

  def numbering_note
    load_marc_from_file 2208462
  end

  def online_access
    load_marc_from_file 4806783
  end

  def online_access_with_colon
    load_marc_from_file 7578923
  end

  def other_authors
    load_marc_from_file 3914143
  end

  def partial_contents
    load_marc_from_file 4838379
  end

  def performers
    load_marc_from_file 363909
  end

  def place
    load_marc_from_file 3754127
  end

  def previous_frequency
    load_marc_from_file 4651293
  end

  def printer_260
    load_marc_from_file 1889602
  end

  def printer_264
    load_marc_from_file 8129261
  end

  def provenance
    load_marc_from_file 8065222
  end

  def provenance_561
    load_marc_from_file 3044467
  end

  def publication_date
    load_marc_from_file 744313
  end

  def no_printer_264
    load_marc_from_file 7326111
  end

  def ranged_time_coverage
    load_marc_from_file 4318191
  end

  def related_material
    load_marc_from_file 8548630
  end

  def related_title
    load_marc_from_file 620407
  end

  def reproductions
    load_marc_from_file 2904384
  end

  def scale
    load_marc_from_file 4315761
  end

  def single_life_date
    load_marc_from_file 3410930
  end

  def single_note
    load_marc_from_file 5539786
  end

  def single_series
    load_marc_from_file 109692
  end

  def single_time_coverage
    load_marc_from_file 2066922
  end

  def subseries_of_info
    load_marc_from_file 2647507
  end

  def summary
    load_marc_from_file 156059
  end

  def summary_880
    load_marc_from_file 6022968
  end

  def supplement_to
    load_marc_from_file 1090172
  end

  def technical_details
    load_marc_from_file 6154492
  end

  def terms_of_service
    load_marc_from_file 3701679
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

  def year_too_long_time_coverage
    load_marc_from_file 2015365
  end
end
