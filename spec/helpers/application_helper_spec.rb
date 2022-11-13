# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#from_marc" do
    subject(:value) { helper.from_marc({document: document, config: {key: "003"}}) }

    it "retrieves the value from the MARC record" do
      expect(value).to eq ["SIRSI"]
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe "#client_in_subnets" do
    context "with staff subnet" do
      subject(:found) { helper.client_in_subnets(helper.staff_subnets) }

      context "when request from onsite" do
        before do
          request.env["REMOTE_ADDR"] = "203.4.202.232"
        end

        it "is false when it does not match a staff IP defined in the config" do
          expect(found).to be true
        end
      end

      context "when request from external" do
        before do
          request.env["REMOTE_ADDR"] = "127.0.0.1"
        end

        it "is true when it matches a staff IP defined in the config" do
          expect(found).to be false
        end
      end
    end

    context "with local subnet" do
      subject(:found) { helper.client_in_subnets(helper.local_subnets) }

      context "when request from local" do
        before do
          request.env["REMOTE_ADDR"] = "192.102.239.232"
        end

        it "is false when it does not match a local IP defined in the config" do
          expect(found).to be true
        end
      end

      context "when request from external" do
        before do
          request.env["REMOTE_ADDR"] = "127.0.0.1"
        end

        it "is true when it matches a local IP defined in the config" do
          expect(found).to be false
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

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
