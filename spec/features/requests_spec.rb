require "rails_helper"

RSpec.describe "Requests" do
  before do
    user = create(:user)
    sign_in user

    allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])
  end

  let(:config) { Rails.application.config_for(:catalogue) }
  let(:solr_document_id) { "1595553" }
  let(:instance_id) { "08aed703-3648-54d0-80ef-fddb3c635731" }
  let(:holdings_id) { "37fbc2dd-3b37-58b8-b447-b538ba7265b9" }
  let(:item_id) { "60ae1cf9-5b4c-5fac-9a38-2cb195cdb7b2" }
  let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_marc, title_tsim: ["National Geographic"], format: ["Journal"]) }

  describe "GET /new" do
    context "when requesting a monograph" do
      it "renders the requesting prompt" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("p", text: I18n.t("requesting.prompt"))
      end

      it "renders the monograph form" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end

    context "when requesting a serial" do
      let(:holdings_id) { "fe525746-5142-5b54-8c89-c6ed7a9c6196" }
      let(:item_id) { "0f17532a-2fcf-5c72-a0c9-751fc459481f" }

      it "renders the requesting prompt" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("p", text: I18n.t("requesting.prompt"))
      end

      it "renders the journals form" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("label", text: I18n.t("requesting.label.year"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.volume"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.enumeration"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end

    context "when requesting a serial manuscript" do
      let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_manuscript_marc, title_tsim: ["Papers of Mem Fox, 1961-2006 [manuscript]"], format: ["Manuscript"]) }
      let(:holdings_id) { "bbc3d88b-eb0d-5739-b37e-a736a265d4a2" }
      let(:item_id) { "fbf144fc-e8ac-5e7d-8da6-69dda3adc9e9" }

      before do
        holdings_response = IO.read("spec/files/catalogue_services/serial_manuscript.json")

        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/instance\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: holdings_response, headers: {"Content-Type" => "application/json"})
      end

      it "renders the multiple box collection message" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(page).to have_css("strong", text: "You have requested a multiple box collection. Please use the fields below to tell our staff which box or boxes you would like to request.")
      end

      it "renders the contact us link" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(page).to have_link(href: Rails.application.config_for(:catalogue).contact_us_url, text: "contact us")
      end

      context "when there is a finding aid url" do
        it "links to the finding aid" do
          visit solr_document_request_new_path(
            solr_document_id: solr_document_id,
            instance: instance_id,
            holdings: holdings_id,
            item: item_id
          )
          expect(page).to have_link(href: "https://nla.gov.au/nla.obj-306101104/findingaid", text: "collection finding aid")
        end
      end

      context "when there is no finding aid url" do
        before do
          allow(document).to receive(:finding_aid_url).and_return(nil)
        end

        it "does not link to the finding aid" do
          visit solr_document_request_new_path(
            solr_document_id: solr_document_id,
            instance: instance_id,
            holdings: holdings_id,
            item: item_id
          )
          expect(page).not_to have_link(text: "collection finding aid")
        end
      end

      it "renders the serial manuscripts from" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(page).to have_css("label", text: I18n.t("requesting.label.box_number"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.series_number"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.folder_item_number"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end
  end

  def serial_marc
    load_marc_from_file 1595553
  end

  def serial_manuscript_marc
    load_marc_from_file 2761
  end
end
