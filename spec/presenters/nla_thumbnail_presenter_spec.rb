# frozen_string_literal: true

require "rails_helper"

RSpec.describe NlaThumbnailPresenter do
  let(:document) { SolrDocument.new(id: 123, marc_ss: sample_marc) }
  # rubocop:disable RSpec/VerifiedDoubles
  let(:view_context) { double "View context" }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:request) { instance_double(ActionDispatch::Request) }
  let(:config) { Blacklight::OpenStructWithHashAccess.new({thumbnail_method: :render_thumbnail, title_field: :title_tsim}) }
  let(:presenter) { described_class.new(document, view_context, config) }
  let(:image_options) { {alt: ""} }
  let(:solr_document_path) { "/catalog/#{document.id}" }

  before do
    allow(view_context).to receive(:request).with(no_args).and_return(request)
  end

  describe "#exists?" do
    subject(:exists) { presenter.exists? }

    context "when thumbnail_method is configured" do
      it "returns true" do
        expect(exists).to be true
      end
    end
  end

  describe "#link_value" do
    subject(:url) { presenter.link_value }

    context "when has online access" do
      it "returns the online access url" do
        allow(document).to receive_messages(online_access: [{href: "https://example.com"}], copy_access: [])

        expect(url).to eq "https://example.com"
      end
    end

    context "when has copy access" do
      it "returns the copy access url" do
        allow(document).to receive_messages(online_access: [], copy_access: [{href: "https://example.com"}])

        expect(url).to eq "https://example.com"
      end
    end
  end

  describe "#alt_title_from_document" do
    subject(:alt_text) { presenter.alt_title_from_document }

    context "when thumbnail_field is configured" do
      # rubocop:disable RSpec/NestedGroups
      context "when the field exists in the document" do
        let(:document) { SolrDocument.new(thumbnail_path_ss: "image.png", title_tsim: "Work Title") }

        it "returns the value from the title field" do
          expect(alt_text).to be "Work Title"
        end
      end

      context "when the field is missing from the document" do
        let(:document) { SolrDocument.new(thumbnail_path_ss: "image.png") }

        it "return nil" do
          expect(alt_text).to be_nil
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  context "when displayed on the index page" do
    let(:config) { Blacklight::OpenStructWithHashAccess.new({key: :index, thumbnail_method: :render_thumbnail, title_field: :title_tsim}) }

    describe "#thumbnail_tag" do
      # rubocop:disable RSpec/NestedGroups
      context "when there is no image" do
        it "returns nil" do
          allow(view_context).to receive(:render_thumbnail).and_return(nil)
          allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/#{document.id}")
          allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(false)

          expect(presenter.thumbnail_tag).to be_nil
        end
      end

      context "when there is no link" do
        it "returns an image tag only" do
          allow(view_context).to receive(:render_thumbnail).and_return('<img src="image.png" alt="Work Title" onerror="this.style.display=\'none\'" class="w-100" />')
          allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/#{document.id}")
          allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(false)

          expect(presenter.thumbnail_tag.include?("href")).to be false
        end
      end

      context "when there is a link" do
        it "returns an image tag inside an anchor" do
          allow(view_context).to receive(:render_thumbnail).and_return('<img src="image.png" alt="Work Title" onerror="this.style.display=\'none\'" class="w-100" />')
          allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(false)
          allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/#{document.id}")
          allow(view_context).to receive(:link_to).with(any_args).and_return(%(<a href="/catalog/#{document.id}"><img src="image.png" alt="Work Title" onerror="this.style.display='none'" class="w-100" /></a>))
          allow(document).to receive(:online_access).and_return([{href: "https://example.com"}])

          expect(presenter.thumbnail_tag.include?("href")).to be true
          expect(presenter.thumbnail_tag.include?("img")).to be true
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  context "when displayed on the show page" do
    let(:config) { Blacklight::OpenStructWithHashAccess.new({key: :show, thumbnail_method: :render_thumbnail, title_field: :title_tsim}) }

    describe "#thumbnail_tag" do
      # rubocop:disable RSpec/NestedGroups
      context "when there is a link" do
        it "returns an image tag inside an anchor" do
          allow(document).to receive(:online_access).and_return([{href: "https://example.com"}])
          allow(view_context).to receive(:render_thumbnail).and_return('<img src="image.png" alt="Work Title" onerror="this.style.display=\'none\'" class="w-100" />')
          allow(view_context).to receive(:link_to).with(any_args).and_return('<a href="https://example.com"><img src="image.png" alt="Work Title" onerror="this.style.display=\'none\'" class="w-100" /></a>')
          allow(document).to receive(:online_access).and_return([{href: "https://example.com"}])
          allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/#{document.id}")
          allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(true)

          expect(presenter.thumbnail_tag.include?("href")).to be true
          expect(presenter.thumbnail_tag.include?("img")).to be true
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe "#is_catalogue_record_page?" do
    subject(:catalogue_page_flag) { presenter.is_catalogue_record_page? }

    context "when displayed on the index page" do
      it "returns false" do
        allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/123")
        allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(false)

        expect(catalogue_page_flag).to be false
      end
    end

    context "when displayed on the catalogue record page" do
      let(:config) { Blacklight::OpenStructWithHashAccess.new({key: :show, thumbnail_field: :thumbnail_path_ss, title_field: :title_tsim, top_level_config: :show}) }

      it "returns true" do
        allow(view_context).to receive(:solr_document_path).with({id: 123}).and_return("/catalog/#{document.id}")
        allow(view_context).to receive(:current_page?).with("/catalog/#{document.id}").and_return(true)

        expect(catalogue_page_flag).to be true
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
