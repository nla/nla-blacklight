# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  include Devise::Test::ControllerHelpers

  let(:document) { SolrDocument.new(marc_ss: sample_marc) }

  describe "#from_marc" do
    subject(:value) { helper.from_marc({document: document, config: {key: "003"}}) }

    it "retrieves the value from the MARC record" do
      expect(value).to eq ["SIRSI"]
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe "#makelink" do
    subject(:link) { helper.makelink(document: document, href: href, text: text) }

    let(:href) { "" }
    let(:text) { "" }

    context "when href not present" do
      it "returns an empty array" do
        expect(link).to eq []
      end
    end

    context "when offsite" do
      context "when an eResource entry exists" do
        let(:document) { SolrDocument.new(marc_ss: ebsco_record, id: 6417357) }
        let(:href) { "http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574" }
        let(:text) { "http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574" }

        it "creates a link to the 'offsite' action" do
          expect(link.first).to include "offsite?"
        end

        context "when extended info is to be displayed" do
          subject(:link) { helper.makelink(document: document, href: href, text: text, extended_info: true) }

          let(:extend_info) { true }

          context "when not logged in" do
            it "generates a caption with the link" do
              expect(link[1]).to include "Log in with your Library card to access this resource"
            end
          end

          context "when logged in" do
            login_user

            it "generates a caption with the link" do
              expect(link[1]).to include "You are logged in and can access this resource"
            end
          end
        end
      end

      context "when no eResource entry exists" do
        let(:document) { SolrDocument.new(marc_ss: sample_record, id: 4157458) }
        let(:href) { "http://purl.access.gpo.gov/GPO/LPS9877" }
        let(:text) { "Text version:" }

        it "does not create a link to the 'offsite' action" do
          expect(link.first).not_to include "/offsite?"
        end
      end
    end

    context "when onsite" do
      before do
        request.env["REMOTE_ADDR"] = "187.121.206.121"
      end

      context "when an eResource entry exists" do
        let(:document) { SolrDocument.new(marc_ss: ebsco_record, id: 6417357) }
        let(:href) { "http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574" }
        let(:text) { "http://search.ebscohost.com/login.aspx?direct=true&scope=site&db=nlebk&db=nlabk&AN=658574" }

        it "creates a link to the 'offsite' action" do
          expect(link.first).to include "offsite?"
        end

        context "when extended info is to be displayed" do
          subject(:link) { helper.makelink(document: document, href: href, text: text, extended_info: true) }

          let(:extend_info) { true }

          it "generates a caption with the link" do
            expect(link[1]).to include "You can access this resource because you are inside the National Library building"
          end
        end
      end

      context "when no eResource entry exists" do
        let(:document) { SolrDocument.new(marc_ss: sample_record, id: 4157458) }
        let(:href) { "http://purl.access.gpo.gov/GPO/LPS9877" }
        let(:text) { "Text version:" }

        it "does not create a link to the 'offsite' action" do
          expect(link.first).not_to include "/offsite?"
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups

  def ebsco_record
    load_marc_from_file 6417357
  end

  def newsbank_record
    load_marc_from_file 3366422
  end

  def macquarie_record
    load_marc_from_file 5757317
  end

  def sample_record
    load_marc_from_file 4157458
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
