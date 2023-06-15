require "rails_helper"

RSpec.describe RelatedRecords do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#collection_id" do
    subject(:record) { described_class.new(document) }

    let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AuCNLDY)318537") }

    it "returns the collection_id_ssi value" do
      expect(record.collection_id).to eq "(AuCNLDY)318537"
    end
  end

  describe "#parent_id" do
    subject(:record) { described_class.new(document) }

    let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872") }

    it "returns the parent_id_ssi value" do
      expect(record.parent_id).to eq "(AKIN)23783872"
    end
  end

  describe "#in_collection?" do
    context "when record only has a collection_id_ssi value and has children" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AuCNLDY)318537") }

      it "returns true" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: count_response, headers: {})

        expect(record.in_collection?).to be true
      end
    end

    context "when record only has a collection_id_ssi value and no children" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AuCNLDY)318537") }

      it "returns false" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: no_count_response, headers: {})

        expect(record.in_collection?).to be false
      end
    end

    context "when record has only a parent_id_ssi value" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872") }

      it "returns true" do
        expect(record.in_collection?).to be true
      end
    end

    context "when record has neither a collection_id_ssi or parent_id_ssi value" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc) }

      it "returns false" do
        expect(record.in_collection?).to be false
      end
    end
  end

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

  describe "#has_children?" do
    subject(:record) { described_class.new(document) }

    let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AKIN)23783872") }

    it "returns true when the result count is greater than 0" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: count_response, headers: {})

      expect(record.has_children?).to be true
    end

    it "returns false when the result count is 0" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: no_count_response, headers: {})

      expect(record.has_children?).to be false
    end
  end

  describe "#parent" do
    context "when there is a parent_id" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872") }

      it "returns the parent record" do
        WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?fl=id,title_tsim&q=collection_id_ssi:%22.*%22&rows=1&sort=score%20desc,%20pub_date_si%20desc,%20title_si%20asc&wt=json/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: parent_response, headers: {})

        expect(record.parent).to eq([{id: "3044380", title: ["Land Rights camp at Heirisson Island, Western Australia, 1978 [picture] / Stephen Smith"]}])
      end
    end

    context "when there is no parent_id" do
      subject(:record) { described_class.new(document) }

      let(:document) { SolrDocument.new(marc_ss: sample_marc) }

      it "returns nil" do
        expect(record.parent).to be_nil
      end
    end
  end

  describe "#child_count" do
    subject(:record) { described_class.new(document) }

    let(:document) { SolrDocument.new(marc_ss: sample_marc, collection_id_ssi: "(AuCNLDY)318537") }

    it "returns the result count" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: count_response, headers: {})

      expect(record.child_count).to be 8
    end

    it "returns 0 when there is no response" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: no_count_response, headers: {})

      expect(record.child_count).to be 0
    end
  end

  describe "#sibling_count" do
    subject(:record) { described_class.new(document) }

    let(:document) { SolrDocument.new(marc_ss: sample_marc, parent_id_ssi: "(AKIN)23783872") }

    it "returns the result count" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: count_response, headers: {})

      expect(record.sibling_count).to be 8
    end

    it "returns 0 when there is no response" do
      WebMock.stub_request(:get, /solr:8983\/solr\/blacklight\/select\?q=parent_id_ssi:%22.*%22&rows=0&wt=json/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: no_count_response, headers: {})

      expect(record.sibling_count).to be 0
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

  def count_response
    IO.read("spec/files/related_records/child_count_response.json")
  end

  def no_count_response
    res = JSON.parse(IO.read("spec/files/related_records/child_count_response.json"))
    res["response"] = nil
    res.to_json
  end

  def parent_response
    IO.read("spec/files/related_records/parent_record_response.json")
  end
end
