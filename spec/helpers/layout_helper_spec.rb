# frozen_string_literal: true

require "rails_helper"

RSpec.describe LayoutHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#main_content_classes" do
    context "when on the home page" do
      before do
        allow(helper).to receive(:current_page?).with(root_path).and_return(true)
      end

      it "returns full width classes" do
        expect(helper.main_content_classes).to eq("col-12")
      end
    end

    context "when not on the home page" do
      before do
        allow(helper).to receive(:current_page?).with(root_path).and_return(false)
      end

      it "returns sidebar width classes" do
        expect(helper.main_content_classes).to eq("col-md-8 col-lg-9")
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
