require "rails_helper"

RSpec.describe RelatedRecords, type: :model do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#in_collection?" do
    subject(:record) { described_class.new(document) }

    context "when there is a collection ID and children" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AKIN)23783872") }

      it "is in a collection" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: children_response_query, headers: {})

        expect(record.in_collection?).to be true
      end
    end

    context "when there is a collection ID and no children" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AKIN)23783872") }

      let(:children_response) do
        response = JSON.parse(children_response_query)
        response["response"]["numFound"] = 0
        response.to_json
      end

      it "is not in a collection" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: children_response, headers: {})

        expect(record.in_collection?).to be false
      end
    end

    context "when there is a collection ID and Solr returns no response" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AKIN)23783872") }

      it "is not in a collection" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent" => "Faraday v1.10.0"
            }
          )
          .to_return(status: 200, body: "", headers: {})

        expect(record.in_collection?).to be false
      end
    end

    context "when there is a parent ID" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872") }

      it "is in a collection" do
        expect(record.in_collection?).to be true
      end
    end

    context "when there is a parent ID and collection ID" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872", collection_id_ssi: "(AuCNLDY)318537") }

      it "is in a collection" do
        expect(record.in_collection?).to be true
      end
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody

  describe "#collection_name" do
    subject(:record) { described_class.new(document) }

    context "when the MARCXML contains the collection name" do
      let(:document) { SolrDocument.new(marc_ss: child_marc) }

      it "returns the value as a single string" do
        expect(record.collection_name).to eq "Land Rights camp at Heirisson Island, Western Australia, 1978"
      end
    end

    context "when the MARCXML does not contain the collection name" do
      it "returns an empty string" do
        expect(record.collection_name).to eq ""
      end
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
    IO.read("spec/files/related_records/collection_count_response.json")
  end
end
