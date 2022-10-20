# frozen_string_literal: true

require "rails_helper"

RSpec.describe FieldHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#url_list" do
    subject(:list) { helper.url_list(document: document, field: "online_access", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { [{text: "Text version:", href: "http://purl.access.gpo.gov/GPO/LPS9877"}] }

      it "generates a link to the item" do
        expect(list).to include '<a href="http://purl.access.gpo.gov/GPO/LPS9877">Text version:</a>'
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
        expect(document).to have_broken_links
      end

      it "starts with the text 'Broken link?'" do
        expect(list).to include "Broken link?"
      end

      it "includes a link to Trove" do
        expect(list).to include "<a href=\"https://webarchive.nla.gov.au/awa/*/http://purl.access.gpo.gov/GPO/LPS9878\">Trove</a>"
      end

      it "includes a link to the Wayback Machine" do
        expect(list).to include "<a href=\"https://web.archive.org/web/*/http://purl.access.gpo.gov/GPO/LPS9878\">Wayback Machine</a>"
      end

      it "includes a link to Google" do
        expect(list).to include "<a href=\"https://www.google.com.au/search?q=&quot;Protocol amending 1949 Convention of Inter-American Tropical Tuna Commission&quot; gpo.gov united states united states united states\">Google</a>"
      end
    end

    context "when there are no broken links" do
      let(:value) { nil }

      let(:document) { SolrDocument.new(marc_ss: no_broken_links_marc) }

      it "does not generate broken links text" do
        expect(document).not_to have_broken_links
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
      let(:value) do
        ["Example A", "Example B"]
      end

      it "generates an unordered list" do
        expect(value_list).to eq "<ul><li>Example A</li>\n<li>Example B</li></ul>"
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
  end

  # rubocop:disable RSpec/NestedGroups
  describe "#notes" do
    subject(:notes_values) { helper.notes(document: document, field: "notes", config: config, value: value, context: "show") }

    context "when there are only non-880 notes" do
      context "with a single non-880 note" do
        let(:value) do
          [{
            notes: ["Non-880 note A"],
            more_notes: []
          }]
        end

        it "generates plain text" do
          expect(notes_values).to eq "Non-880 note A"
        end
      end

      context "with multiple non-880 notes" do
        let(:value) do
          [{
            notes: ["Non-880 note A", "Non-880 note B"],
            more_notes: []
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>Non-880 note A</li><li>Non-880 note B</li></ul>"
        end
      end
    end

    context "when there are only 880 notes" do
      context "with a single 880 note" do
        let(:value) do
          [{
            notes: [],
            more_notes: ["880 note A"]
          }]
        end

        it "generates plain text" do
          expect(notes_values).to eq "880 note A"
        end
      end

      context "with multiple 880 notes" do
        let(:value) do
          [{
            notes: [],
            more_notes: ["880 note A", "880 note B"]
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>880 note A</li><li>880 note B</li></ul>"
        end
      end
    end

    context "when there are both non-800 and 880 notes" do
      context "with a single non-880 note" do
        let(:value) do
          [{
            notes: ["non-880 Note A"],
            more_notes: ["880 Note 1", "880 Note 2"]
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>880 Note 1</li><li>880 Note 2</li></ul>"
        end
      end

      context "with a single 880 note" do
        let(:value) do
          [{
            notes: ["non-880 Note A", "non-880 Note B"],
            more_notes: ["880 Note 1"]
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li></ul>"
        end
      end

      context "with multiple non-880 and 880 notes" do
        let(:value) do
          [{
            notes: ["non-880 Note A", "non-880 Note B"],
            more_notes: ["880 Note 1", "880 Note 2"]
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li><li>880 Note 2</li></ul>"
        end
      end
    end

    context "when there is a URL in the note" do
      context "with a single note" do
        let(:value) { [{notes: ["Online copy found at https://google.com"], more_notes: []}] }

        it "generates a link to the online copy" do
          expect(notes_values).to eq "Online copy found at <a href=\"https://google.com\">https://google.com</a>"
        end

        it "message starts with 'Online copy found at'" do
          expect(notes_values).to start_with "Online copy found at"
        end
      end

      context "with multiple notes" do
        let(:value) do
          [{
            notes: ["Online copy found at https://google.com"],
            more_notes: ["Author website https://example.com"]
          }]
        end

        it "generates an unordered list" do
          expect(notes_values).to eq "<ul><li>Online copy found at <a href=\"https://google.com\">https://google.com</a></li><li>Author website <a href=\"https://example.com\">https://example.com</a></li></ul>"
        end
      end

      context "with a URL containing a query string" do
        let(:value) { [{notes: ["Online copy found at https://example.com?author=Joe+Smith&title=Naming Is Hard"], more_notes: []}] }

        it "is expected to include a link to the resource" do
          expect(notes_values).to eq "Online copy found at <a href=\"https://example.com?author=Joe+Smith&title=Naming\">https://example.com?author=Joe+Smith&title=Naming</a> Is Hard"
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe "#map_search" do
    subject(:map_search_value) { helper.map_search(document: document, field: "map_search", config: config, value: value, context: "show") }

    let(:value) { ["https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030"] }

    it "generates a link to Map Search" do
      expect(map_search_value).to eq "<a href=\"https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030\">View this map in Map Search</a>"
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

    let(:copyright) { object_double(CopyrightInfo.new(document), info: copyright_response_hash) }
    let(:value) { [copyright] }

    it "renders the copyright component" do
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_SERVICE_URL" => "https://example.com/copyright/"))
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_FAIR_DEALING_URL" => "https://example.com/fair_dealing"))
      stub_const("ENV", ENV.to_hash.merge("COPYRIGHT_CONTACT_URL" => "https://example.com/contact-us"))

      stub_request(:get, "https://example.com/copyright/")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v1.10.0"
          }
        )
        .to_return(status: 200, body: "", headers: {})

      allow(copyright).to receive(:document).and_return(document)
      allow(copyright).to receive(:info).and_return(copyright_response_hash)

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
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: "", headers: {})

        allow(copyright).to receive(:document).and_return(document)
        allow(copyright).to receive(:info).and_return(copyright_response_hash)

        expect(copyright_component).to be_nil
      end
    end
  end

  describe "#build_subject_search_list" do
    subject(:subject_list_value) do
      helper.build_subject_search_list(document: document, field: "subject_ssim", config: config, value: value, context: "show")
    end

    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 1111, subject_ssim: value) }

    context "when there are subjects" do
      let(:value) do
        [
          "Band music, Arranged -- Scores and parts",
          "Marches (Band), Arranged -- Scores and parts"
        ]
      end

      it "creates a single string with links to subject searches" do
        expect(subject_list_value).to eq '<a href="/?search_field=subject_ssim&amp;q=%22Band+music%2C+Arranged+--+Scores+and+parts%22">Band music, Arranged -- Scores and parts</a> | <a href="/?search_field=subject_ssim&amp;q=%22Marches+%28Band%29%2C+Arranged+--+Scores+and+parts%22">Marches (Band), Arranged -- Scores and parts</a>'
      end
    end

    context "when there are no subjects" do
      let(:value) { [] }

      it "returns an empty array" do
        expect(subject_list_value).to be_nil
      end
    end
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end

  def no_broken_links_marc
    IO.read("spec/files/marc/113030.marcxml")
  end

  def copyright_response
    IO.read("spec/files/copyright/service_response.xml")
  end

  def copyright_response_hash
    Hash.from_xml(copyright_response.to_s)["response"]["itemList"]["item"]
  end
end
