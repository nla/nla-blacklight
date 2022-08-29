# frozen_string_literal: true

require "rails_helper"

RSpec.describe FieldHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:show) }

  describe "#url_list" do
    subject { helper.url_list(document: document, field: "online_access", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { [{text: "Text version:", href: "http://purl.access.gpo.gov/GPO/LPS9877"}] }

      it { is_expected.to include '<a href="http://purl.access.gpo.gov/GPO/LPS9877">Text version:</a>' }
    end

    context "when there are multiple items" do
      let(:value) do
        [
          {text: "Text version:", href: "http://purl.access.gpo.gov/GPO/LPS9877"},
          {text: "PDF version:", href: "http://purl.access.gpo.gov/GPO/LPS9878"}
        ]
      end

      it { is_expected.to include "<a href=\"http://purl.access.gpo.gov/GPO/LPS9877\">Text version:</a>" }

      it { is_expected.to include "<a href=\"http://purl.access.gpo.gov/GPO/LPS9878\">PDF version:</a>" }
    end

    context "when there are broken links" do
      let(:value) do
        [
          {text: "PDF version:", href: "http://purl.access.gpo.gov/GPO/LPS9878"}
        ]
      end

      it { expect(document).to have_broken_links }

      it { is_expected.to include "Broken link?" }

      it { is_expected.to include "<a href=\"https://webarchive.nla.gov.au/awa/*/http://purl.access.gpo.gov/GPO/LPS9878\">Trove</a>" }

      it { is_expected.to include "<a href=\"https://web.archive.org/web/*/http://purl.access.gpo.gov/GPO/LPS9878\">Wayback Machine</a>" }

      it { is_expected.to include "<a href=\"https://www.google.com.au/search?q=&quot;Protocol amending 1949 Convention of Inter-American Tropical Tuna Commission&quot; gpo.gov united states united states united states\">Google</a>" }
    end
  end

  describe "#list" do
    subject { helper.list(document: document, field: "series", config: config, value: value, context: "show") }

    context "when there is only a single item" do
      let(:value) { ["Example A"] }

      it { is_expected.to eq "Example A" }
    end

    context "when there are multiple items" do
      let(:value) do
        ["Example A", "Example B"]
      end

      it { is_expected.to eq "<ul><li>Example A</li>\n<li>Example B</li></ul>" }
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe "#notes" do
    subject { helper.notes(document: document, field: "notes", config: config, value: value, context: "show") }

    context "when there are only non-880 notes" do
      context "with a single non-880 note" do
        let(:value) do
          [{
            notes: ["Non-880 note A"],
            more_notes: []
          }]
        end

        it { is_expected.to eq "Non-880 note A" }
      end

      context "with multiple non-880 notes" do
        let(:value) do
          [{
            notes: ["Non-880 note A", "Non-880 note B"],
            more_notes: []
          }]
        end

        it { is_expected.to eq "<ul><li>Non-880 note A</li><li>Non-880 note B</li></ul>" }
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

        it { is_expected.to eq "880 note A" }
      end

      context "with multiple 880 notes" do
        let(:value) do
          [{
            notes: [],
            more_notes: ["880 note A", "880 note B"]
          }]
        end

        it { is_expected.to eq "<ul><li>880 note A</li><li>880 note B</li></ul>" }
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

        it { is_expected.to eq "<ul><li>non-880 Note A</li><li>880 Note 1</li><li>880 Note 2</li></ul>" }
      end

      context "with a single 880 note" do
        let(:value) do
          [{
            notes: ["non-880 Note A", "non-880 Note B"],
            more_notes: ["880 Note 1"]
          }]
        end

        it { is_expected.to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li></ul>" }
      end

      context "with multiple non-880 and 880 notes" do
        let(:value) do
          [{
            notes: ["non-880 Note A", "non-880 Note B"],
            more_notes: ["880 Note 1", "880 Note 2"]
          }]
        end

        it { is_expected.to eq "<ul><li>non-880 Note A</li><li>non-880 Note B</li><li>880 Note 1</li><li>880 Note 2</li></ul>" }
      end
    end

    context "when there is a URL in the note" do
      context "with a single note" do
        let(:value) { [{notes: ["Online copy found at https://google.com"], more_notes: []}] }

        it { is_expected.to eq "Online copy found at <a href=\"https://google.com\">https://google.com</a>" }
      end

      context "with multiple notes" do
        let(:value) do
          [{
            notes: ["Online copy found at https://google.com"],
            more_notes: ["Author website https://example.com"]
          }]
        end

        it { is_expected.to eq "<ul><li>Online copy found at <a href=\"https://google.com\">https://google.com</a></li><li>Author website <a href=\"https://example.com\">https://example.com</a></li></ul>" }
      end

      context "with a URL containing a query string" do
        let(:value) { [{notes: ["Online copy found at https://example.com?author=Joe+Smith&title=Naming Is Hard"], more_notes: []}] }

        it { is_expected.to eq "Online copy found at <a href=\"https://example.com?author=Joe+Smith&title=Naming\">https://example.com?author=Joe+Smith&title=Naming</a> Is Hard" }
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  describe "#map_search" do
    subject { helper.map_search(document: document, field: "map_search", config: config, value: value, context: "show") }

    let(:value) { ["https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030"] }

    it { is_expected.to eq "<a href=\"https://mapsearch.nla.gov.au/?type=map&mapClassifications=all&geolocation=all&text=113030\">View this map in Map Search</a>" }
  end

  # Need to set the MARC source field to actual MARC XML in order to allow
  # the "#to_marc" method to be included in the SolrDocument model.
  def sample_marc
    IO.read("spec/files/marc/4157458.marcxml")
  end
end
