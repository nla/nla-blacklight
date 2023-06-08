# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlacklightHelper do
  describe "#application_name" do
    it "defaults to 'Catalogue | National Library of Australia'" do
      expect(application_name).to eq "Catalogue | National Library of Australia"
    end
  end

  describe "#render_page_title" do
    it "defaults to the application name" do
      expect(helper.render_page_title).to eq helper.application_name
    end

    context "when in development environment" do
      before { ENV["RAILS_ENV"] = "development" }

      it "prepends '[DEV]' to the title" do
        expect(helper.render_page_title).to eq "[DEV] #{helper.application_name}"
      end
    end

    context "when in staging environment" do
      before { ENV["RAILS_ENV"] = "staging" }

      it "prepends '[TEST]' to the title" do
        expect(helper.render_page_title).to eq "[TEST] #{helper.application_name}"
      end
    end
  end

  describe "#render_document_heading" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc) }

    context "when apostrophes are present as HTML entities" do
      before do
        # rubocop:disable RSpec/VerifiedDoubles
        allow(helper).to receive(:presenter).and_return(double(heading: "Mayor&#39;s Stone"))
        # rubocop:enable RSpec/VerifiedDoubles
      end

      it "converts them to standard apostrophes" do
        expect(helper.render_document_heading).to eq "<h4 itemprop=\"name\" class=\"h3 col\">Mayor&#39;s Stone</h4>"
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
