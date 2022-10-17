require "rails_helper"

RSpec.describe RelatedRecordsComponent, type: :component do
  let(:view_context) { controller.view_context }
  let(:field_config) { Blacklight::Configuration::Field.new(key: "related_records", label: "Related Records", accessor: :related_records, component: described_class) }
  let(:field) do
    Blacklight::FieldPresenter.new(view_context, document, field_config)
  end
  let(:children_response) { children_response_query }

  before do
    WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Faraday v1.10.0"
        }
      )
      .to_return(status: 200, body: children_response, headers: {})
  end

  context "when record is part of a collection" do
    let(:document) { SolrDocument.new(marc_ss: child_marc, id: 2076183, parent_id_ssi: "(AKIN)23783872") }

    it "renders the collection details" do
      render_inline(described_class.new(field: field, show: true))

      expect(page.text).to include "Related Records:"
    end

    context "when record has a collection title" do
      it "renders the collection title" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to include "In collection: Land Rights camp at Heirisson Island, Western Australia, 1978"
      end
    end

    context "when record has no collection title" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc) }

      it "does not render the collection title" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: children_response, headers: {})

        render_inline(described_class.new(field: field, show: true))

        expect(page.text).not_to include "In collection: Land Rights camp at Heirisson Island, Western Australia, 1978"
      end
    end

    context "when record is a collection-level record" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AuCNLDY)318537") }

      it "renders the collection-level label" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to include "This is a collection-level record."
      end
    end

    context "when record is in a collection" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AuCNLDY)318537") }

      it "renders the collection-level label" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to include "This record belongs in a collection."
      end
    end

    context "when record is both a collection-level record and part of a collection" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872", collection_id_ssi: "(AuCNLDY)318537") }

      it "renders the a label stating both collection and part of collection" do
        render_inline(described_class.new(field: field, show: true))

        expect(page.text).to include "This record belongs in a collection and is also a collection-level record."
      end
    end
  end

  context "when record is not part of a collection" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc) }

    it "does not render the collection details" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent" => "Faraday v1.10.0"
          }
        )
        .to_return(status: 200, body: "", headers: {})

      render_inline(described_class.new(field: field, show: true))

      expect(page.text).not_to include "Related Records:"
    end
  end

  def sample_marc
    "<record>
      <leader>01182pam a22003014a 4500</leader>
      <controlfield tag='001'>a4802615</controlfield>
      <controlfield tag='003'>SIRSI</controlfield>
      <controlfield tag='008'>020828s2003    enkaf    b    001 0 eng  </controlfield>
      <datafield tag='245' ind1='0' ind2='0'>
        <subfield code='a'>Apples :</subfield>
        <subfield code='b'>botany, production, and uses /</subfield>
        <subfield code='c'>edited by D.C. Ferree and I.J. Warrington.</subfield>
      </datafield>
      <datafield tag='260' ind1=' ' ind2=' '>
        <subfield code='a'>Oxon, U.K. ;</subfield>
        <subfield code='a'>Cambridge, MA :</subfield>
        <subfield code='b'>CABI Pub.,</subfield>
        <subfield code='c'>c2003.</subfield>
      </datafield>
      <datafield tag='700' ind1='1' ind2=' '>
        <subfield code='a'>Ferree, David C.</subfield>
        <subfield code='q'>(David Curtis),</subfield>
        <subfield code='d'>1943-</subfield>
      </datafield>
      <datafield tag='700' ind1='1' ind2=' '>
        <subfield code='a'>Warrington, I. J.</subfield>
        <subfield code='q'>(Ian J.)</subfield>
      </datafield>
    </record>"
  end

  def child_marc
    load_marc_from_file 2076183
  end

  def children_response_query
    IO.read("spec/files/collections/collection_children_response.json")
  end
end
