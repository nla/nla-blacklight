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
    "<record xmlns='http://www.loc.gov/MARC21/slim'>
      <leader>02507cam a2200433 a 4500</leader>
      <controlfield tag='001'>4157458</controlfield>
      <controlfield tag='005'>20171214151243.0</controlfield>
      <controlfield tag='007'>he bmb---bbca</controlfield>
      <controlfield tag='008'>010305s2001    dcu     b    f000 0 eng c</controlfield>
      <datafield ind1=' ' ind2=' ' tag='035'>
        <subfield code='a'>(OCoLC)46368408</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='035'>
        <subfield code='a'>4157458</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='040'>
        <subfield code='a'>GPO</subfield>
        <subfield code='b'>eng</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='042'>
        <subfield code='a'>pcc</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='074'>
        <subfield code='a'>0996-A</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='074'>
        <subfield code='a'>0996-A (online)</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='074'>
        <subfield code='a'>0996-B (MF)</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='074'>
        <subfield code='a'>0996-B (online)</subfield>
      </datafield>
      <datafield ind1='0' ind2=' ' tag='086'>
        <subfield code='a'>Y 1.1/4:107-2</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='091'>
        <subfield code='a'>mfm</subfield>
      </datafield>
      <datafield ind1='0' ind2=' ' tag='130'>
        <subfield code='a'>Convention on the Establishment of an Inter-American Tropical Tuna Commission</subfield>
        <subfield code='d'>(1949).</subfield>
        <subfield code='k'>Protocols, etc.,</subfield>
        <subfield code='d'>1999 June 11.</subfield>
      </datafield>
      <datafield ind1='1' ind2='0' tag='245'>
        <subfield code='a'>Protocol amending 1949 Convention of Inter-American Tropical Tuna Commission</subfield>
        <subfield code='h'>[microform] :</subfield>
        <subfield code='b'>message from the President of the United States transmitting protocol to amend the 1949 Convention on the Establishment of an Inter-American Tropical Tuna Commission, done at Guayaquil, June 11, 1999, and signed by the United States, subject to ratification, in Guayaquil, Ecuador, on the same date.</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='260'>
        <subfield code='a'>Washington :</subfield>
        <subfield code='b'>U.S. G.P.O.,</subfield>
        <subfield code='c'>2001.</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='300'>
        <subfield code='a'>vii, 10 p. ;</subfield>
        <subfield code='c'>23 cm.</subfield>
      </datafield>
      <datafield ind1='1' ind2=' ' tag='490'>
        <subfield code='a'>Treaty doc. ;</subfield>
        <subfield code='v'>107-2</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='500'>
        <subfield code='a'>At head of title: 107th Congress, 1st session. Senate.</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='500'>
        <subfield code='a'>&quot;Referred to the Committee on Foreign Relations.&quot;</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='500'>
        <subfield code='a'>Distributed to some depository libraries in microfiche.</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='500'>
        <subfield code='a'>Shipping list no.: 2001-0113-P.</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='500'>
        <subfield code='a'>&quot;January 8, 2001.&quot;</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='530'>
        <subfield code='a'>Also available via Internet from the GPO Access web site. Addresses as of 3/1/01: http://frwebgate.access.gpo.gov/cgi-bin/useftp.cgi?IPaddress=162.140.64.21&amp;filename=td002.107&amp;directory=/diskb/wais/data/107c̲ongd̲ocuments (text version), http://frwebgate.access.gpo.gov/cgi-bin/useftp.cgi?IPaddress=162.140.64.21&amp;filename=td002.pdf&amp;directory=/diskb/wais/data/107c̲ongd̲ocuments (PDF version); current access is available via PURLs.</subfield>
      </datafield>
      <datafield ind1='2' ind2='0' tag='610'>
        <subfield code='a'>Inter-American Tropical Tuna Commission</subfield>
        <subfield code='x'>Membership.</subfield>
      </datafield>
      <datafield ind1=' ' ind2='0' tag='650'>
        <subfield code='a'>Tuna fisheries</subfield>
        <subfield code='x'>Law and legislation.</subfield>
      </datafield>
      <datafield ind1='1' ind2=' ' tag='710'>
        <subfield code='a'>United States.</subfield>
        <subfield code='b'>President (1993-2001 : Clinton)</subfield>
      </datafield>
      <datafield ind1='1' ind2=' ' tag='710'>
        <subfield code='a'>United States.</subfield>
        <subfield code='b'>Congress.</subfield>
        <subfield code='b'>Senate.</subfield>
        <subfield code='b'>Committee on Foreign Relations.</subfield>
      </datafield>
      <datafield ind1='1' ind2=' ' tag='710'>
        <subfield code='a'>United States.</subfield>
        <subfield code='t'>Convention on the Establishment of an Inter-American Tropical Tuna Commission</subfield>
        <subfield code='d'>(1949).</subfield>
        <subfield code='k'>Protocols, etc.,</subfield>
        <subfield code='d'>1999 June 11.</subfield>
      </datafield>
      <datafield ind1=' ' ind2='0' tag='830'>
        <subfield code='a'>Treaty doc. ;</subfield>
        <subfield code='v'>107-2.</subfield>
      </datafield>
      <datafield ind1='4' ind2='1' tag='856'>
        <subfield code='3'>Text version:</subfield>
        <subfield code='u'>http://purl.access.gpo.gov/GPO/LPS9877</subfield>
      </datafield>
      <datafield ind1='4' ind2='1' tag='856'>
        <subfield code='3'>PDF version:</subfield>
        <subfield code='u'>http://purl.access.gpo.gov/GPO/LPS9878</subfield>
        <subfield code='z'>Adobe Acrobat Reader required</subfield>
      </datafield>
      <datafield ind1=' ' ind2=' ' tag='984'>
        <subfield code='a'>ANL</subfield>
        <subfield code='c'>mc SUDOC Y 1.1/4:107-2</subfield>
      </datafield>
    </record>"
  end
end
