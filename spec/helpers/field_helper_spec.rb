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
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end
end
