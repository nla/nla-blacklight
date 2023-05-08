# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueRecordActionsComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Picture"]) }

  before do
    Flipper.enable(:requesting)
  end

  it "renders the 'Order a copy' button" do
    render_inline(described_class.new(document: document))

    expect(page.text).to include("Order a copy")
  end

  context "when the document is a picture" do
    it "renders the 'View at library' button" do
      render_inline(described_class.new(document: document))

      expect(page.text).to include("View at library")
    end
  end

  context "when the document is not a picture" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Book"]) }

    it "renders the 'Request' button" do
      render_inline(described_class.new(document: document))

      expect(page.text).to include("Request")
    end
  end

  context "when not available online" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Book"]) }

    it "does not render the 'View online' button" do
      allow(document).to receive(:copy_access).and_return([])

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("View online")
    end
  end

  context "when available online" do
    it "renders the 'View at library' button" do
      allow(document).to receive(:copy_access).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

      render_inline(described_class.new(document: document))

      expect(page.text).to include("View online")
    end
  end

  # feature flag: :requesting
  context "when requesting is disabled" do
    before do
      Flipper.disable(:requesting)
    end

    context "when the document is a picture" do
      it "does not render the 'View at library' button" do
        render_inline(described_class.new(document: document))

        expect(page.text).not_to include("View at library")
      end
    end

    context "when the document is not a picture" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Book"]) }

      it "does not render the 'Request' button" do
        render_inline(described_class.new(document: document))

        expect(page.text).not_to include("Request")
      end
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end
end
