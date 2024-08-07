# frozen_string_literal: true

require "rails_helper"

RSpec.describe Eresources do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#initialize" do
    subject(:eresources) { described_class.new }

    context "when the eResources manager return a 200 status" do
      it "caches the current config" do
        stub_const("ENV", ENV.to_hash.merge("ERESOURCES_CONFIG_URL" => "http://eresource-manager.example.com/"))

        expect(eresources.entries).not_to be_blank
      end
    end
  end

  describe "#url_append" do
    context "when there is a '?' in the URL" do
      subject(:url) { described_class.new.url_append("https://example.com?param=test", "NLAOriginalUrl=http://original-url.com") }

      it "prepends '&' to the param" do
        expect(url).to eq "https://example.com?param=test&NLAOriginalUrl=http://original-url.com"
      end
    end

    context "when there is no '?' in the URL" do
      subject(:url) { described_class.new.url_append("https://example.com", "param=test") }

      it "prepends '?' to the param" do
        expect(url).to eq "https://example.com?param=test"
      end
    end
  end

  describe "#known_url" do
    context "when it is a known eResource with no remote URL" do
      subject(:eresources_link) { described_class.new.known_url("http://m.worldbk.com/") }

      let(:entry) { {"remoteaccess" => "yes", "remoteurl" => "", "title" => "World Book Online", "urlstem" => %w[http://www.worldbookonline.com http://m.worldbk.com/]} }

      it "generates an EZProxy link" do
        stub_const("ENV", ENV.to_hash.merge("ERESOURCES_CONFIG_URL" => "http://eresource-manager.example.com"))

        expect(eresources_link).to eq({type: "ezproxy", url: "http://m.worldbk.com/", entry: entry})
      end
    end

    # There currently aren't any entries with a "remoteurl"
    context "when it is a known eResource with a remote URL" do
      subject(:eresources_link) do
        eresources = described_class.new
        entries = eresources.instance_variable_get(:@entries)
        entries << {"remoteaccess" => "yes", "remoteurl" => "https://example.com", "title" => "Example Remote URL", "urlstem" => %w[http://example.com]}
        eresources.instance_variable_set(:@entries, entries)

        eresources.known_url("http://example.com/test")
      end

      let(:entry) { {"remoteaccess" => "yes", "remoteurl" => "https://example.com", "title" => "Example Remote URL", "urlstem" => %w[http://example.com]} }

      it "generates a remote URL link" do
        stub_const("ENV", ENV.to_hash.merge("ERESOURCES_CONFIG_URL" => "http://eresource-manager.example.com"))

        expect(eresources_link).to eq({type: "remoteurl", url: "https://example.com?NLAOriginalUrl=http://example.com/test", entry: entry})
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
end
