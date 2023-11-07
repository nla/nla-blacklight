# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueRecordActionsComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Picture"]) }

  it "renders the 'Order a copy' button" do
    render_inline(described_class.new(document: document))

    expect(page.text).to include("Order a copy")
  end

  it "renders the 'Request' button" do
    allow(document).to receive(:copy_access).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

    render_inline(described_class.new(document: document))

    expect(page.text).to include("Request")
  end

  context "when item is a NED item" do
    it "does not render the 'Request' button" do
      allow(document).to receive_messages(copy_access: [], system_control_number: ["(AU-CaNED)NED248338P743467"])

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("Request")
    end
  end

  context "when available online" do
    it "renders the 'View online' button" do
      allow(document).to receive(:copy_access).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

      render_inline(described_class.new(document: document))

      expect(page).to have_link("View online", href: "https://nla.gov.au/nla.obj-123456789")
    end

    context "when the document is an electronic resource" do
      it "renders the 'View online' button with an ezproxy link" do
        allow(document).to receive_messages(has_eresources?: true, online_access: [{href: "https://ancestrylibrary.proquest.com"}])
        allow(document).to receive(:fetch).with(any_args).and_call_original
        allow(document).to receive(:fetch).with("call_number_tsim").and_return(["ELECTRONIC RESOURCE"])

        render_inline(described_class.new(document: document))

        expect(page).to have_link("View online", href: "/catalog/4157485/offsite?url=https%3A%2F%2Fancestrylibrary.proquest.com")
      end
    end

    context "when the document is audio" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Audio"]) }

      it "renders the 'Listen' button" do
        allow(document).to receive(:copy_access).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

        render_inline(described_class.new(document: document))

        expect(page).to have_link("Listen", href: "https://nla.gov.au/nla.obj-123456789")
      end
    end
  end

  context "when not available online" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Book"]) }

    it "does not render the 'View online' button" do
      allow(document).to receive(:copy_access).and_return([])

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("View online")
    end

    context "when the document is audio" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Audio"]) }

      it "renders the 'Listen' button" do
        allow(document).to receive(:copy_access).and_return([])

        render_inline(described_class.new(document: document))

        expect(page.text).not_to include("Listen")
      end
    end

    context "when item is electronic and has physical holdings" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, call_number_tsim: ["INTERNET", "mc SUDOC Y 1.1/4:107-2"]) }

      it "renders the 'Request' button and holdings" do
        render_inline(described_class.new(document: document))

        expect(page.text).to include("Request")
      end
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end
end
