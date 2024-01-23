# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UrlHelper" do
  let(:document) { SolrDocument.new(id: "123", title_tsim: "Test link", marc_ss: sample_marc, nlaobjid_ss: "nla.obj-123") }
  let(:current_search) { Search.create(query_params: {q: ""}) }
  let(:blacklight_config) do
    Blacklight::Configuration.new.configure do |config|
      config.index.title_field = "title_tsim"
      config.index.display_type_field = "format"
    end
  end
  let(:parameter_class) { ActionController::Parameters }

  before do
    allow(controller).to receive(:controller_name).and_return("catalog")
    allow(helper).to receive_messages(search_session: current_search)
    allow(helper).to receive_messages(blacklight_config: blacklight_config)
  end

  describe "#link_to_document" do
    it "has the text-break class" do
      expect(helper.link_to_document(document, counter: 1)).to match(/text-break/)
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
