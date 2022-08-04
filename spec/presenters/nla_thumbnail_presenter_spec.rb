# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/NestedGroups
RSpec.describe NlaThumbnailPresenter do
  let(:document) { SolrDocument.new }
  let(:view_context) { instance_double(ActionView::Base) }
  let(:config) { Blacklight::Configuration.new.view_config(:index) }
  let(:presenter) { described_class.new(document, view_context, config) }
  let(:image_options) { {alt: ""} }

  describe "#exists?" do
    subject { presenter.exists? }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :thumbnail_path_ss)
      end

      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png") }

        it { is_expected.to be true }
      end

      context "when the field is missing from the document" do
        it { is_expected.to be false }
      end
    end
  end

  describe "#link_value" do
    subject { presenter.link_value }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new(thumbnail_field: :thumbnail_path_ss)
      end

      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "https://nla.gov.au/nla.obj-1234566789") }

        it { is_expected.to be "https://nla.gov.au/nla.obj-1234566789" }
      end

      context "when the field is missing from the document" do
        it { is_expected.to be_nil }
      end
    end
  end

  describe "#alt_title_from_document" do
    subject { presenter.alt_title_from_document }

    context "when thumbnail_field is configured" do
      let(:config) do
        Blacklight::OpenStructWithHashAccess.new({thumbnail_field: :thumbnail_path_ss, title_field: :title_tsim})
      end

      context "when the field exists in the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png", "title_tsim" => "Work Title") }

        it { is_expected.to be "Work Title" }
      end

      context "when the field is missing from the document" do
        let(:document) { SolrDocument.new("thumbnail_path_ss" => "image.png") }

        it { is_expected.to be_nil }
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
