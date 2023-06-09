# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThumbnailHelper do
  describe "#render_thumbnail" do
    context "when document has not Bib ID" do
      it "returns nil" do
        expect(helper.render_thumbnail(SolrDocument.new)).to be_nil
      end
    end

    context "when an image is found via Bib ID" do
      it "returns an image tag" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/thumbnail\/retrieve\?bibId=123/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: bib_id_image, headers: {})

        expect(helper.render_thumbnail(SolrDocument.new(id: 123, marc_ss: sample_marc))).to match(/img/)
      end
    end

    context "when an image is found via ISBN" do
      let(:document) { SolrDocument.new(id: 123, marc_ss: sample_marc) }

      it "returns an image tag" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/thumbnail\/retrieve\?bibId=123&isbnList=8559378&width=123/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: isbn_image, headers: {"content-type": "image/jpeg"})

        allow(document).to receive(:isbn).and_return(["8559378"])

        expect(helper.render_thumbnail(document, {})).to match(/img/)
      end
    end

    context "when an image is found via LCCN" do
      let(:document) { SolrDocument.new(id: 123, marc_ss: sample_marc) }

      it "returns an image tag" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/thumbnail\/retrieve\?bibId=123&lccList=93002529&width=123/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: lccn_image, headers: {"content-type": "image/jpeg"})

        allow(document).to receive(:lccn).and_return(["93002529"])

        expect(helper.render_thumbnail(document, {})).to match(/img/)
      end
    end
  end

  def bib_id_image
    IO.read("spec/files/thumbnails/bib_id.png")
  end

  def isbn_image
    IO.read("spec/files/thumbnails/isbn.png")
  end

  def lccn_image
    IO.read("spec/files/thumbnails/lccn.png")
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
end
