# frozen_string_literal: true

require "rails_helper"

RSpec.describe CatalogueRecordActionsComponent, type: :component do
  let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Picture"]) }

  describe "#dfl_document?" do
    it "memoizes a false result" do
      component = described_class.new(document: document)
      allow(component).to receive(:is_dfl_for_document?).with(document).and_return(false)

      2.times { component.dfl_document? }

      expect(component).to have_received(:is_dfl_for_document?).once
    end
  end

  context "when the document contains a DFL item" do
    let(:document) do
      SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Picture"], folio_instance_id_ssim: ["folio-instance-id"])
    end
    let(:catalogue_services_client) { instance_double(CatalogueServicesClient) }
    let(:component) { described_class.new(document: document) }

    before do
      stub_const("RequestItemHelper::DFL_ENABLED", true)
      allow(CatalogueServicesClient).to receive(:new).and_return(catalogue_services_client)
      allow(component).to receive(:user_name_display).and_return("")
      allow(catalogue_services_client).to receive(:get_holdings).with(instance_id: "folio-instance-id").and_return([
        {"itemRecords" => [{"loanType" => "DFL"}]}
      ])
    end

    it "renders an external RefTracker request link" do
      render_inline(component)

      link = page.find_by_id("request-btn")
      expect(link.text).to eq "Request to Use in the Library"
      expect(link["target"]).to eq "_top"
      expect(URI.parse(link["href"]).host).to eq "reftrackertest.nla.gov.au"
    end
  end

  it "renders the 'Order a copy' button" do
    render_inline(described_class.new(document: document))

    expect(page.text).to include("Order a scan")
  end

  it "renders the 'Request' button" do
    allow(document).to receive(:copy_access_urls).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

    render_inline(described_class.new(document: document))

    expect(page.text).to include("Use in the Library")
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is `true`" do
    it "does not render the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return("true")

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("Use in the Library")
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is `false`" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return("false")

      render_inline(described_class.new(document: document))

      expect(page.text).to include("Use in the Library")
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is defined without a value" do
    it "renders the request button" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("FOLIO_UPDATE_IN_PROGRESS").and_return("")

      render_inline(described_class.new(document: document))

      expect(page.text).to include("Use in the Library")
    end
  end

  context "when FOLIO_UPDATE_IN_PROGRESS is not defined" do
    it "renders the request button" do
      render_inline(described_class.new(document: document))

      expect(page.text).to include("Use in the Library")
    end
  end

  context "when item is a NED item" do
    it "does not render the 'Request' button" do
      allow(document).to receive_messages(copy_access_urls: [], system_control_number: ["(AU-CaNED)NED248338P743467"])

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("Use in the Library")
    end
  end

  context "when available online" do
    it "renders the 'View online' button" do
      allow(document).to receive(:copy_access_urls).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

      render_inline(described_class.new(document: document))

      expect(page).to have_link("View online", href: "https://nla.gov.au/nla.obj-123456789")
    end

    context "when the document is an electronic resource" do
      it "renders the 'View online' button with an ezproxy link" do
        allow(document).to receive_messages(has_eresources?: true, online_access_urls: [{href: "https://ancestrylibrary.proquest.com"}], callnumber: ["ELECTRONIC RESOURCE"])
        allow(document).to receive(:fetch).with(any_args).and_call_original

        render_inline(described_class.new(document: document))

        expect(page).to have_link("View online", href: "/catalog/4157485/offsite?url=https%3A%2F%2Fancestrylibrary.proquest.com")
      end
    end

    context "when the document is audio" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Audio"]) }

      it "renders the 'Listen' button" do
        allow(document).to receive(:copy_access_urls).and_return([{href: "https://nla.gov.au/nla.obj-123456789"}])

        render_inline(described_class.new(document: document))

        expect(page).to have_link("Listen", href: "https://nla.gov.au/nla.obj-123456789")
      end
    end
  end

  context "when not available online" do
    let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Book"]) }

    it "does not render the 'View online' button" do
      allow(document).to receive(:copy_access_urls).and_return([])

      render_inline(described_class.new(document: document))

      expect(page.text).not_to include("View online")
    end

    context "when the document is audio" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, id: 4157485, format: ["Audio"]) }

      it "renders the 'Listen' button" do
        allow(document).to receive(:copy_access_urls).and_return([])

        render_inline(described_class.new(document: document))

        expect(page.text).not_to include("Listen")
      end
    end

    context "when item is electronic and has physical holdings" do
      let(:document) { SolrDocument.new(marc_ss: sample_marc, call_number_tsim: ["INTERNET", "mc SUDOC Y 1.1/4:107-2"]) }

      it "renders the 'Request' button and holdings" do
        render_inline(described_class.new(document: document))

        expect(page.text).to include("Use in the Library")
      end
    end
  end

  def sample_marc
    load_marc_from_file 4157458
  end
end
