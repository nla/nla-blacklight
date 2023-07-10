# frozen_string_literal: true

require "rails_helper"

RSpec.describe RelatedRecordsComponent, type: :component do
  let(:view_context) { controller.view_context }
  let(:field_config) { Blacklight::Configuration::Field.new(key: "related_records", label: "Related Records", accessor: :related_records, component: described_class) }
  let(:document) { SolrDocument.new }
  let(:related_records) { document.related_records }
  let(:collection_id) { "" }

  context "when record is a parent in a collection" do
    before do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22\(AKIN\)14156869%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: child_count_query_response, headers: {})

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?fl=id,title_tsim&q=collection_id_ssim:%22\(AKIN\)14156869%22&rows=1&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: no_parent_query_response, headers: {})
    end

    let(:document) { SolrDocument.new(marc_ss: parent_record_marc) }

    it "states this is a collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This is a collection"
    end

    it "links to the collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This collection contains"
      expect(page).to have_link("8 records", href: "/catalog?q=%22%28AKIN%2914156869%22&search_field=in_collection")
    end

    it "renders the 'two-level parent' hierarchy icon" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page).to have_css("#two-level-parent")
    end
  end

  context "when records is a child in a collection" do
    before do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22\(AuCNLDY\)318537%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: no_count_response, headers: {})

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22\(AKIN\)23783872%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: sibling_count_response, headers: {})

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?fl=id,title_tsim&q=collection_id_ssim:%22\(AKIN\)23783872%22&rows=1&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: parent_query_response, headers: {})
    end

    let(:document) { SolrDocument.new(marc_ss: child_record_marc) }

    it "states this is a collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This belongs to the"
      expect(page).to have_link("Land Rights camp at Heirisson Island, Western Australia, 1978", href: "/catalog/3044380")
    end

    it "links to the collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This collection contains"
      expect(page).to have_link("11 records", href: "/catalog?q=%22%28AKIN%2923783872%22&search_field=in_collection")
    end

    it "renders the 'two-level child' hierarchy icon" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page).to have_css("#two-level-child")
    end
  end

  context "when record is a child in a collection and parent of a collection" do
    before do
      child_count = JSON.parse(child_count_query_response)
      child_count["response"]["numFound"] = 177

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22\(AKIN\)10887198%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: child_count.to_json, headers: {})

      sibling_count = JSON.parse(sibling_count_response)
      sibling_count["response"]["numFound"] = 5

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22\(AKIN\)24850123%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: sibling_count.to_json, headers: {})

      parent_response = JSON.parse(parent_query_response)
      parent_response["response"]["docs"][0] = {id: "1586062", title_tsim: "Dunlop family photograph albums"}

      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?fl=id,title_tsim&q=collection_id_ssim:%22\(AKIN\)24850123%22&rows=1&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: parent_response.to_json, headers: {})
    end

    let(:document) { SolrDocument.new(marc_ss: child_parent_record_marc) }

    it "states this is a collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This is part of the"
      expect(page).to have_link("Dunlop family photograph albums", href: "/catalog/1586062")
    end

    it "links to sibling collections" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "There are"
      expect(page).to have_link("5 related collections", href: "/catalog?q=%22%28AKIN%2924850123%22&search_field=in_collection")
    end

    it "links to the collection" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page.text).to include "This collection contains"
      expect(page).to have_link("177 records", href: "/catalog?q=%22%28AKIN%2910887198%22&search_field=in_collection")
    end

    it "renders the 'three-level child' hierarchy icon" do
      render_inline(described_class.new(related_records: related_records.first))

      expect(page).to have_css("#three-level-child")
    end
  end

  context "when record is not part of a collection" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc) }

    it "does not render the collection details" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssim:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: "", headers: {})

      render_inline(described_class.new(related_records: related_records))

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

  def parent_record_marc
    load_marc_from_file 1585818
  end

  def child_record_marc
    load_marc_from_file 554064
  end

  def child_parent_record_marc
    load_marc_from_file 1585528
  end

  def child_count_query_response
    IO.read("spec/files/related_records/child_count_response.json")
  end

  def no_count_response
    res = JSON.parse(child_count_query_response)
    res["response"] = nil
    res.to_json
  end

  def sibling_count_response
    res = JSON.parse(child_count_query_response)
    res["response"]["numFound"] = 11
    res.to_json
  end

  def children_query_response
    IO.read("spec/files/related_records/child_records_response.json")
  end

  def parent_query_response
    IO.read("spec/files/related_records/parent_record_response.json")
  end

  def no_parent_query_response
    IO.read("spec/files/related_records/no_parent_record_response.json")
  end
end
