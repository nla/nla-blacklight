# frozen_string_literal: true

require "rails_helper"

RSpec.describe FieldHelper do
  let(:document) { SolrDocument.new(id: 123, marc_ss: sample_marc, title_start_tsim: ["Protocol amending 1949 Convention of Inter-American Tropical Tuna Commission"], cited_authors_tsim: ["United States."]) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#url_list" do
    subject(:list) { helper.url_list(document: document, field: "online_access", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { [{text: "Text version:", href: "http://purl.access.gpo.gov/GPO/LPS9877"}] }

      it "generates a link to the item" do
        expect(list).to include '<a class="text-break" href="http://purl.access.gpo.gov/GPO/LPS9877">Text version:</a>'
      end
    end

    context "when there are multiple items" do
      let(:value) do
        [
          {text: "Text version:", href: "http://purl.access.gpo.gov/GPO/LPS9877"},
          {text: "PDF version:", href: "http://purl.access.gpo.gov/GPO/LPS9878"}
        ]
      end

      it "generates links to multiple items" do
        expect(list.size).to be > 1
      end
    end

    context "when there are broken links" do
      let(:value) do
        [
          {text: "PDF version:", href: "http://purl.access.gpo.gov/GPO/LPS9878"}
        ]
      end

      it "generates broken links text" do
        expect(document.broken_links).not_to be_nil
      end

      it "starts with the text 'Broken link?'" do
        expect(list).to include "Broken link?"
      end

      it "includes a link to Trove" do
        expect(list).to include "<a class=\"text-break\" href=\"https://webarchive.nla.gov.au/awa/*/http://purl.access.gpo.gov/GPO/LPS9878\">Trove</a>"
      end

      it "includes a link to the Wayback Machine" do
        expect(list).to include "<a class=\"text-break\" href=\"https://web.archive.org/web/*/http://purl.access.gpo.gov/GPO/LPS9878\">Wayback Machine</a>"
      end

      it "includes a link to Google" do
        expect(list).to include "<a class=\"text-break\" href=\"https://www.google.com.au/search?q=&quot;Protocol amending 1949 Convention of Inter-American Tropical Tuna Commission&quot; gpo.gov united states\">Google</a>"
      end
    end

    context "when there are no broken links" do
      let(:value) { nil }

      let(:document) { SolrDocument.new(marc_ss: no_broken_links_marc, title_start_tsim: ["Canberra"]) }

      it "does not generate broken links text" do
        expect(document.broken_links).to be_nil
      end
    end

    context "when there aren't broken links for url" do
      let(:value) {
        [{
          text: "Online version. Click on provided links to display issues available; then click on index of city codes to view particular issues.",
          href: "https://purl.access.gpo.gov/GPO/LPS1384"
        }]
      }

      let(:document) { SolrDocument.new(marc_ss: some_broken_links_marc, title_start_tsim: ["Washington monthly local climatological data"]) }

      it "does not generate broken links text" do
        expect(document.broken_links[value.first[:href]]).to be_nil
      end
    end
  end

  describe "#list" do
    subject(:value_list) { helper.list(document: document, field: "series", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { ["Example A"] }

      it "generates plain text" do
        expect(value_list).to eq "Example A"
      end
    end

    context "when there are multiple items" do
      let(:value) { ["Example A", "Example B"] }

      it "generates an unordered list" do
        expect(value_list).to eq "<ul><li>Example A</li>\n<li>Example B</li></ul>"
      end
    end

    context "when there is a URL in the text" do
      let(:value) { ["Example: https://google.com/test.pdf"] }

      it "generates a link around the URL" do
        expect(value_list).to eq "Example: <a href=\"https://google.com/test.pdf\" class=\"text-break\">https://google.com/test.pdf</a>"
      end
    end
  end

  describe "#unstyled_list" do
    subject(:value_list) { helper.unstyled_list(document: document, field: "series", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { ["Example A"] }

      it "generates plain text" do
        expect(value_list).to eq "Example A"
      end
    end

    context "when there are multiple items" do
      let(:value) do
        ["Example A", "Example B"]
      end

      it "generates an unordered list" do
        expect(value_list).to eq "<ul class=\"list-unstyled\"><li>Example A</li>\n<li>Example B</li></ul>"
      end
    end

    context "when there is a URL in the text" do
      let(:value) { ["Example: https://google.com/test.pdf"] }

      it "generates a link around the URL" do
        expect(value_list).to eq "Example: <a href=\"https://google.com/test.pdf\" class=\"text-break\">https://google.com/test.pdf</a>"
      end
    end
  end

  describe "#emphasized_list" do
    subject(:value_list) { helper.emphasized_list(document: document, field: "access_conditions", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { ["Access condition A"] }

      it "generates emphasized plain text" do
        expect(value_list).to eq "<strong>Access condition A</strong>"
      end
    end

    context "when there are multiple items" do
      let(:value) do
        ["Access condition A", "Access condition B"]
      end

      it "generates a list of emphasized text" do
        expect(value_list).to eq "<ul><li><strong>Access condition A</strong></li>\n<li><strong>Access condition B</strong></li></ul>"
      end
    end

    context "when there is a URL in the text" do
      let(:value) { ["Example: https://google.com/test.pdf"] }

      it "generates a link around the URL" do
        expect(value_list).to eq "<strong>Example: <a href=\"https://google.com/test.pdf\" class=\"text-break\">https://google.com/test.pdf</a></strong>"
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe "#notes" do
    subject(:notes_values) { helper.notes(document: document, field: "notes", config: config, value: value, context: "show") }

    context "when there are only non-880 notes" do
      context "with a single non-880 note" do
        let(:value) do
          ["Non-880 note A"]
        end

        it "generates plain text" do
          expect(notes_values).to eq "Non-880 note A"
        end
      end

      context "with multiple non-880 notes" do
        let(:value) do
          ["Non-880 note A", "Non-880 note B"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>Non-880 note A</li><li>Non-880 note B</li></ul>"
        end
      end
    end

    context "when there are only 880 notes" do
      context "with a single 880 note" do
        let(:value) do
          ["880 note A"]
        end

        it "generates plain text" do
          expect(notes_values).to eq "880 note A"
        end
      end

      context "with multiple 880 notes" do
        let(:value) do
          ["880 note A", "880 note B"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>880 note A</li><li>880 note B</li></ul>"
        end
      end
    end

    context "when there are both non-800 and 880 notes" do
      context "with a single non-880 note" do
        let(:value) do
          ["non-880 Note A", "880 Note 1", "880 Note 2"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>880 Note 1</li><li>880 Note 2</li></ul>"
        end
      end

      context "with a single 880 note" do
        let(:value) do
          ["non-880 Note A", "non-880 Note B", "880 Note 1"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li></ul>"
        end
      end

      context "with multiple non-880 and 880 notes" do
        let(:value) do
          ["non-880 Note A", "non-880 Note B", "880 Note 1", "880 Note 2"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li><li>880 Note 2</li></ul>"
        end
      end
    end

    context "when there is a URL in the note" do
      context "with a single note" do
        let(:value) { ["Online copy found at https://google.com"] }

        it "generates a link to the online copy" do
          expect(notes_values).to eq "Online copy found at <a href=\"https://google.com\" class=\"text-break\">https://google.com</a>"
        end

        it "message starts with 'Online copy found at'" do
          expect(notes_values).to start_with "Online copy found at"
        end
      end

      context "with multiple notes" do
        let(:value) do
          ["Online copy found at https://google.com", "Author website https://example.com"]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>Online copy found at <a href=\"https://google.com\" class=\"text-break\">https://google.com</a></li><li>Author website <a href=\"https://example.com\" class=\"text-break\">https://example.com</a></li></ul>"
        end
      end

      context "with a URL containing a query string" do
        let(:value) { ["Online copy found at https://example.com?author=Joe+Smith&title=Naming Is Hard"] }

        it "is expected to include a link to the resource" do
          expect(notes_values).to eq "Online copy found at <a href=\"https://example.com?author=Joe+Smith&title=Naming\" class=\"text-break\">https://example.com?author=Joe+Smith&title=Naming</a> Is Hard"
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe "#map_search" do
    subject(:map_search_value) { helper.map_search(document: document, field: "map_search", config: config, value: value, context: "show") }

    let(:value) { ["https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030"] }

    it "generates a link to Map Search" do
      expect(map_search_value).to eq '<a class="text-break" href="https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030">View this map in Map Search</a>'
    end

    context "when there is no value" do
      subject(:map_search_value) { helper.map_search(document: document, field: "map_search", config: config, value: value, context: "show") }

      let(:value) { nil }

      it "does not display the map search link" do
        expect(map_search_value).to be_nil
      end
    end
  end

  describe "#render_copyright_component" do
    subject(:copyright_component) { helper.render_copyright_component(document: document, field: "", config: config, value: value, context: "show") }

    before do
      view.lookup_context.view_paths.push "#{Rails.root}/app/components/"
    end

    let(:value) { [copyright_response_hash] }

    it "renders the copyright component" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

      stub_request(:get, "https://example.com/copyright/")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: "", headers: {})

      expect(copyright_component).to include "In Copyright"
    end

    context "when there is no value" do
      let(:value) { nil }

      it "does not render the copyright component" do
        stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
        stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
        stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

        stub_request(:get, "https://example.com/copyright/")
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "", headers: {})

        expect(copyright_component).to be_nil
      end
    end
  end

  describe "#subject_search_list" do
    subject(:subject_search_list_value) do
      helper.subject_search_list(document: document, field: "subject", config: config, value: value, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 1111, subject: value, subject_ssim: value) }

    context "when there is a single subject" do
      let(:value) do
        [
          "Band music, Arranged -- Scores and parts"
        ]
      end

      it "does not render a list" do
        expect(subject_search_list_value).not_to include "ul"
        expect(subject_search_list_value).not_to include "li"
        expect(subject_search_list_value).to include "search_field=subject"
        expect(subject_search_list_value).to include "q=%22Band+music%2C+Arranged+--+Scores+and+parts%22"
        expect(subject_search_list_value).to include "Band music, Arranged -- Scores and parts"
      end
    end

    context "when there are multiple subjects" do
      let(:value) do
        [
          "Band music, Arranged -- Scores and parts",
          "Marches (Band), Arranged -- Scores and parts"
        ]
      end

      it "renders an unstyled list" do
        expect(subject_search_list_value).to include "ul"
        expect(subject_search_list_value).to include "li"
        expect(subject_search_list_value).to include "list-unstyled"
        expect(subject_search_list_value).to include "search_field=subject"
        expect(subject_search_list_value).to include "q=%22Band+music%2C+Arranged+--+Scores+and+parts%22"
        expect(subject_search_list_value).to include "Band music, Arranged -- Scores and parts"
        expect(subject_search_list_value).to include "q=%22Marches+%28Band%29%2C+Arranged+--+Scores+and+parts%22"
        expect(subject_search_list_value).to include "Marches (Band), Arranged -- Scores and parts"
      end
    end

    context "when there are no subjects" do
      let(:value) { [] }

      it "returns an empty string" do
        expect(subject_search_list_value).to be_nil
      end
    end
  end

  describe "#aiatsis_subject_search_list" do
    subject(:aiatsis_subject_search_list_value) do
      helper.aiatsis_subject_search_list(document: document, field: "indigenous_subject", config: config, value: value, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 1111, subject: value, aiatsis_subject_ssim: value) }

    context "when there is a single subject" do
      let(:value) do
        [
          "Band music, Arranged -- Scores and parts"
        ]
      end

      it "does not render a list" do
        expect(aiatsis_subject_search_list_value).not_to include "ul"
        expect(aiatsis_subject_search_list_value).not_to include "li"
        expect(aiatsis_subject_search_list_value).to include "search_field=indigenous_subject"
        expect(aiatsis_subject_search_list_value).to include "q=%22Band+music%2C+Arranged+--+Scores+and+parts%22"
        expect(aiatsis_subject_search_list_value).to include "Band music, Arranged -- Scores and parts"
      end
    end

    context "when there are multiple subjects" do
      let(:value) do
        [
          "Band music, Arranged -- Scores and parts",
          "Marches (Band), Arranged -- Scores and parts"
        ]
      end

      it "renders an unstyled list" do
        expect(aiatsis_subject_search_list_value).to include "ul"
        expect(aiatsis_subject_search_list_value).to include "li"
        expect(aiatsis_subject_search_list_value).to include "list-unstyled"
        expect(aiatsis_subject_search_list_value).to include "search_field=indigenous_subject"
        expect(aiatsis_subject_search_list_value).to include "q=%22Band+music%2C+Arranged+--+Scores+and+parts%22"
        expect(aiatsis_subject_search_list_value).to include "Band music, Arranged -- Scores and parts"
        expect(aiatsis_subject_search_list_value).to include "q=%22Marches+%28Band%29%2C+Arranged+--+Scores+and+parts%22"
        expect(aiatsis_subject_search_list_value).to include "Marches (Band), Arranged -- Scores and parts"
      end
    end

    context "when there are no subjects" do
      let(:value) { [] }

      it "returns an empty string" do
        expect(aiatsis_subject_search_list_value).to be_nil
      end
    end
  end

  describe "#author_search_list" do
    subject(:author_search_list_value) do
      helper.author_search_list(document: document, field: "author_with_relator_ssim", config: config, value: values, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 1111, author_with_relator_ssim: values, author_ssim: search_values) }

    context "when there is a single author" do
      let(:values) { ["Joe Bloggs, author, illustrator"] }
      let(:search_values) { ["Joe Bloggs"] }

      it "will render a linked search for the author" do
        expect(author_search_list_value).to include "Joe Bloggs, author, illustrator"
        expect(author_search_list_value).to include "search_field=author"
        expect(author_search_list_value).to include "q=%22Joe+Bloggs%22"
      end
    end

    context "when there are multiple authors" do
      let(:values) { ["Joe Bloggs, author, illustrator", "Sally Seashell, author"] }
      let(:search_values) { ["Joe Bloggs", "Sally Seashell"] }

      it "will render an unstyled list of linked searches for the authors" do
        expect(author_search_list_value).to include "ul"
        expect(author_search_list_value).to include "li"
        expect(author_search_list_value).to include "list-unstyled"
        expect(author_search_list_value).to include "Joe Bloggs, author, illustrator"
        expect(author_search_list_value).to include "search_field=author"
        expect(author_search_list_value).to include "q=%22Joe+Bloggs%22"
        expect(author_search_list_value).to include "Sally Seashell, author"
        expect(author_search_list_value).to include "search_field=author"
        expect(author_search_list_value).to include "q=%22Sally+Seashell%22"
      end
    end
  end

  describe "#paragraphs" do
    subject(:summary_value) do
      helper.paragraphs(document: document, field: "summary", config: config, value: value, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 1111, summary: value) }

    context "when there are summaries" do
      let(:value) { ["Summary A", "Summary B"] }

      it "renders multiple paragraphs" do
        expect(summary_value).to eq "<p class=\"mb-0\">Summary A</p><p class=\"mb-0\">Summary B</p>"
      end
    end

    context "when there are no summaries" do
      let(:value) { [] }

      it "does not render any paragraphs" do
        expect(summary_value).to be_nil
      end
    end

    context "when there is a URL in the text" do
      let(:value) { ["Example: https://google.com/test.pdf"] }

      it "generates a link around the URL" do
        expect(summary_value).to eq "<p class=\"mb-0\">Example: <a href=\"https://google.com/test.pdf\" class=\"text-break\">https://google.com/test.pdf</a></p>"
      end
    end
  end

  describe "#occupation_search_list" do
    subject(:occupation_search_list_value) do
      helper.occupation_search_list(document: document, field: "occupation", config: config, value: value, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: occupation, id: 1111) }

    context "when there is a single occupation" do
      let(:value) { %w[Soldiers.] }

      it "does not render a list" do
        expect(occupation_search_list_value).not_to include "ul"
        expect(occupation_search_list_value).not_to include "li"
        expect(occupation_search_list_value).to include "search_field=occupation"
        expect(occupation_search_list_value).to include "q=%22Soldiers.%22"
      end
    end

    context "when there are multiple occupations" do
      let(:value) { %w[Soldiers. Missionaries.] }

      it "renders an unstyled list" do
        expect(occupation_search_list_value).to include "ul"
        expect(occupation_search_list_value).to include "li"
        expect(occupation_search_list_value).to include "list-unstyled"
        expect(occupation_search_list_value).to include "search_field=occupation"
        expect(occupation_search_list_value).to include "q=%22Soldiers.%22"
        expect(occupation_search_list_value).to include "q=%22Missionaries.%22"
      end
    end

    context "when there are no occupations" do
      let(:value) { [] }

      it "returns an empty string" do
        expect(occupation_search_list_value).to be_nil
      end
    end
  end

  describe "#genre_search_list" do
    subject(:genre_search_list_value) do
      helper.genre_search_list(document: document, field: "occupation", config: config, value: value, context: "show")
    end

    context "when there is a single genre" do
      let(:value) { %w[test] }

      it "does not render a list" do
        expect(genre_search_list_value).not_to include "ul"
        expect(genre_search_list_value).not_to include "li"
        expect(genre_search_list_value).to include "search_field=genre"
        expect(genre_search_list_value).to include "q=%22test%22"
      end
    end

    context "when there are multiple genres" do
      let(:value) { %w[test genre] }

      it "renders an unstyled list" do
        expect(genre_search_list_value).to include "ul"
        expect(genre_search_list_value).to include "li"
        expect(genre_search_list_value).to include "list-unstyled"
        expect(genre_search_list_value).to include "search_field=genre"
        expect(genre_search_list_value).to include "q=%22test%22"
        expect(genre_search_list_value).to include "q=%22genre%22"
      end
    end

    context "when there are no genres" do
      let(:value) { [] }

      it "returns an empty string" do
        expect(genre_search_list_value).to be_nil
      end
    end
  end

  describe "#title_search_list" do
    subject(:title_search_list_value) do
      helper.title_search_list(document: document, field: "has_supplement", config: config, value: value, context: "show")
    end

    context "when there is a single title" do
      let(:value) { %w[test] }

      it "does not render a list" do
        expect(title_search_list_value).not_to include "ul"
        expect(title_search_list_value).not_to include "li"
        expect(title_search_list_value).to include "search_field=title"
        expect(title_search_list_value).to include "q=%22test%22"
      end
    end

    context "when there are multiple titles" do
      let(:value) { %w[test test] }

      it "renders an bulleted list" do
        expect(title_search_list_value).to include "ul"
        expect(title_search_list_value).to include "li"
        expect(title_search_list_value).not_to include "list-unstyled"
        expect(title_search_list_value).to include "search_field=title"
        expect(title_search_list_value).to include "q=%22test%22"
        expect(title_search_list_value).to include "q=%22test%22"
      end
    end

    context "when there are no titles" do
      let(:value) { [] }

      it "returns an empty string" do
        expect(title_search_list_value).to be_nil
      end
    end
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    load_marc_from_file 4157458
  end

  def no_broken_links_marc
    load_marc_from_file 113030
  end

  def some_broken_links_marc
    load_marc_from_file 3823089
  end

  def full_contents_marc
    load_marc_from_file 1455669
  end

  def copyright_response
    IO.read("spec/files/copyright/service_response.xml")
  end

  def copyright_response_hash
    Hash.from_xml(copyright_response.to_s)["response"]["itemList"]["item"]
  end

  def occupation
    load_marc_from_file 1070015
  end
end
