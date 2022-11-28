# frozen_string_literal: true

require "rails_helper"

RSpec.describe NlaThumbnailPresenter do
  let(:document) { SolrDocument.new }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:index) }
  let(:presenter) { described_class.new(document, view_context, config) }
  let(:image_options) { {alt: ""} }

  describe "#exists?" do
    subject(:exists) { presenter.exists? }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :thumbnail_path_ss)
      end

      # rubocop:disable RSpec/NestedGroups
      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png") }

        it "returns true" do
          expect(exists).to be true
        end
      end

      context "when the field is missing from the document" do
        it "returns false" do
          expect(exists).to be false
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe "#link_value" do
    subject(:url) { presenter.link_value }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :thumbnail_path_ss)
      end

      # rubocop:disable RSpec/NestedGroups
      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "https://nla.gov.au/nla.obj-1234566789") }

        it "returns the indexed thumbnail image" do
          expect(url).to be "https://nla.gov.au/nla.obj-1234566789"
        end
      end

      context "when the field is missing from the document" do
        it "returns nil" do
          expect(url).to be_nil
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe "#alt_title_from_document" do
    subject(:alt_text) { presenter.alt_title_from_document }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new({thumbnail_field: :thumbnail_path_ss, title_field: :title_tsim})
      end

      # rubocop:disable RSpec/NestedGroups
      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png", "title_tsim" => "Work Title") }

        it "returns the value from the title field" do
          expect(alt_text).to be "Work Title"
        end
      end

      context "when the field is missing from the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png") }

        it "return nil" do
          expect(alt_text).to be_nil
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe "#thumbnail_tag" do
    let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png", "title_tsim" => "Work Title") }

    context "when displayed on the index page" do
      subject(:tag) { presenter.thumbnail_tag }

      let(:config) { Blacklight::OpenStructWithHashAccess.new({thumbnail_field: :thumbnail_path_ss, title_field: :title_tsim}) }
      let(:presenter) { described_class.new(document, view_context, config) }

      it "generates a small linked thumbnail" do
        allow(view_context).to receive(:image_tag).with("image.png/image?wid=123", {alt: "Work Title", onerror: "this.style.display='none'"})
          .and_return('<img src="image.png/image?wid=123" alt="Work Title" onerror="this.style.display=\'none\'" />')

        allow(view_context).to receive(:link_to_document).with(document, '<img src="image.png/image?wid=123" alt="Work Title" onerror="this.style.display=\'none\'" />', {})
          .and_return('<a href="http://example.com/catalog/1"><img src="image.png/image?wid=123" alt="Work Title" onerror="this.style.display=\'none\'" /></a>')

        expect(tag).to include 'href="http://example.com/catalog/1"'

        expect(tag).to include "?wid=123"

        expect(tag).to include 'onerror="this.style.display=\'none\'"'
      end
    end

    context "when displayed on the catalogue record page" do
      subject(:tag) { presenter.thumbnail_tag }

      let(:config) { Blacklight::OpenStructWithHashAccess.new({thumbnail_field: :thumbnail_path_ss, title_field: :title_tsim, top_level_config: :show}) }
      let(:presenter) { described_class.new(document, view_context, config) }

      it "generates a small linked thumbnail" do
        allow(view_context).to receive(:image_tag).with("image.png/image?wid=500", {alt: "Work Title", onerror: "this.style.display='none'"})
          .and_return('<img src="image.png/image?wid=500" alt="Work Title" onerror="this.style.display=\'none\'" />')

        allow(view_context).to receive(:link_to_document).with(document, '<img src="image.png/image?wid=500" alt="Work Title" onerror="this.style.display=\'none\'" />', {})
          .and_return('<a href="https://nla.gov.au/nla.obj1234567"><img src="image.png/image?wid=500" alt="Work Title" onerror="this.style.display=\'none\'" /></a>')

        expect(tag).to include 'href="https://nla.gov.au/nla.obj1234567"'

        expect(tag).to include "?wid=500"

        expect(tag).to include 'onerror="this.style.display=\'none\'"'
      end
    end
  end
end
