require "rails_helper"

RSpec.describe "Requests" do
  before do
    user = create(:user)
    sign_in user

    allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return(document)
  end

  let(:config) { Rails.application.config_for(:catalogue) }

  describe "GET /new" do
    let(:instance_id) { "08aed703-3648-54d0-80ef-fddb3c635731" }
    let(:holdings_id) { "37fbc2dd-3b37-58b8-b447-b538ba7265b9" }
    let(:item_id) { "60ae1cf9-5b4c-5fac-9a38-2cb195cdb7b2" }
    let(:solr_document_id) { "1595553" }
    let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_marc, folio_instance_id_ssim: [instance_id], title_tsim: ["National Geographic"], format: ["Journal"]) }

    context "when user has reached their request limit" do
      it "renders the request limit error" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestLimitReached\": \"true\"}", headers: {})

        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css(".alert-error", text: "Your request limit has been reached")
        expect(page).to have_no_css("#request-details")
      end
    end

    context "when requesting a monograph" do
      it "does not render a message" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page.html).not_to include(I18n.t("requesting.multi_box_prompt"))
        expect(page).to have_no_css("p", text: I18n.t("requesting.prompt"))
      end

      it "renders the monograph form" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("dd", text: I18n.t("requesting.request_held_text"))
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

        expect(page).to have_css("strong", text: "You are requesting a journal, magazine, newspaper, annual report or other multi-part item. Please use the fields below to tell our staff which issues you would like to request.")
        expect(page).to have_css("p", text: "You can use one request for consecutive parts. A separate request must be placed for non-sequential years/volumes or days/months. Requests for large amounts of material may be partially supplied. If you need assistance with this please contact us.")

        expect(page).to have_link(href: Rails.application.config_for(:catalogue).contact_us_url, text: "contact us")
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
        expect(page).to have_css("dd", text: I18n.t("requesting.request_held_text"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end

    context "when requesting a serial manuscript" do
      let(:instance_id) { "31a9dc35-4361-5211-a1b5-a848c40d415a" }
      let(:holdings_id) { "bbc3d88b-eb0d-5739-b37e-a736a265d4a2" }
      let(:item_id) { "fbf144fc-e8ac-5e7d-8da6-69dda3adc9e9" }
      let(:solr_document_id) { "2761" }
      let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_manuscript_marc, folio_instance_id_ssim: [instance_id], title_tsim: ["Papers of Mem Fox, 1961-2006 [manuscript]"], format: ["Manuscript"], finding_aid_url_ssim: ["https://nla.gov.au/nla.obj-306101104/findingaid"]) }

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
        expect(page).to have_css("strong", text: "You are requesting a multiple box collection. Please use the fields below to tell our staff which box or boxes you would like to request.")
        expect(page).to have_css("p", text: "You can use one request for up to five consecutive boxes. Use a separate request for non-consecutive boxes/series/folders/items.")
        expect(page).to have_css("p", text: "If available, use the collection finding aid to select your box number, or a series/folder/item number and enter them below. If you need assistance with this please contact us.")

        expect(page).to have_link("contact us", href: Rails.application.config_for(:catalogue).contact_us_url)
      end

      it "renders the contact us link" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(page).to have_link("contact us", href: Rails.application.config_for(:catalogue).contact_us_url)
      end

      context "when there is a finding aid url" do
        it "links to the finding aid" do
          visit solr_document_request_new_path(
            solr_document_id: solr_document_id,
            instance: instance_id,
            holdings: holdings_id,
            item: item_id
          )
          expect(page).to have_link("collection finding aid", href: "https://nla.gov.au/nla.obj-306101104/findingaid")
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
          expect(page).to have_css("body")
          expect(page).to have_no_link(text: "collection finding aid")
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
        expect(page).to have_css("dd", text: I18n.t("requesting.request_held_text"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end

    context "when requesting a map" do
      let(:instance_id) { "9a5e9fea-38ff-5f0b-8515-3da168d2f370" }
      let(:holdings_id) { "933de73c-6ba0-5626-a663-cb928ae9de62" }
      let(:item_id) { "a30c302b-c7fd-5185-a218-9759c07bfd58" }
      let(:solr_document_id) { "1832134" }
      let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: map_marc, folio_instance_id_ssim: [instance_id], title_tsim: ["Map sheet [cartographic material] / Division of Mines and Geology, State of California, Department of Conservation"], format: ["Map"]) }

      before do
        holdings_response = IO.read("spec/files/catalogue_services/map.json")

        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/instance\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: holdings_response, headers: {"Content-Type" => "application/json"})
      end

      it "renders the requesting prompt" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page.html).to include(I18n.t("requesting.map_prompt"))
      end

      it "renders the map form" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("label", text: "Map Sheet No. or Name*:")
        expect(page).to have_css("label", text: I18n.t("requesting.label.year"))
        expect(page).to have_css("dd", text: I18n.t("requesting.request_held_text"))
        expect(page).to have_css("label", text: I18n.t("requesting.label.notes"))
      end
    end

    context "when requesting a picture", skip: "waiting for planets to align" do
      let(:instance_id) { "d63dc349-8153-5ff6-a33c-f3ec13faa0f0" }
      let(:holdings_id) { "13341598-814f-5407-893b-cc76f339f123" }
      let(:item_id) { "3556c738-2a32-5b11-b86e-2e5db34bbe1e" }
      let(:solr_document_id) { "2921885" }
      let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: map_marc, folio_instance_id_ssim: [instance_id], title_tsim: ["Photographs for The Australian homestead [picture] / Wesley Stacey"], format: ["Picture"], finding_aid_url_ssim: ["https://nla.gov.au/nla.obj-144094084/findingaid"]) }

      before do
        holdings_response = IO.read("spec/files/catalogue_services/picture.json")

        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/instance\/(.*)/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: holdings_response, headers: {"Content-Type" => "application/json"})
      end

      it "renders the requesting prompt" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page.html).to include(I18n.t("requesting.picture_prompt"))
      end

      it "renders the picture form" do
        visit solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("label", text: I18n.t("requesting.label.call_numbers"))
      end

      context "when there is a finding aid url" do
        it "links to the finding aid" do
          visit solr_document_request_new_path(
            solr_document_id: solr_document_id,
            instance: instance_id,
            holdings: holdings_id,
            item: item_id
          )
          expect(page).to have_link("collection finding aid", href: "https://nla.gov.au/nla.obj-144094084/findingaid")
        end
      end
    end
  end

  describe "GET /success" do
    let(:instance_id) { "08aed703-3648-54d0-80ef-fddb3c635731" }
    let(:holdings_id) { "37fbc2dd-3b37-58b8-b447-b538ba7265b9" }
    let(:item_id) { "60ae1cf9-5b4c-5fac-9a38-2cb195cdb7b2" }
    let(:solr_document_id) { "1595553" }
    let(:document) {
      SolrDocument.new(id: solr_document_id, marc_ss: serial_marc, folio_instance_id_ssim: [instance_id],
        title_tsim: ["National Geographic"], format: ["Journal"])
    }

    it "renders the 'Back to item' button" do
      visit solr_document_request_success_path(
        solr_document_id: solr_document_id,
        instance: instance_id,
        holdings: holdings_id,
        item: item_id
      )

      expect(page).to have_link(I18n.t("requesting.btn_back_to_item"), href: "/catalog/1595553")
      expect(page).to have_link("Request page", href: account_requests_path)
    end

    context "when a catalogue search has been performed" do
      let(:current_search) { Search.create(query_params: {q: ""}) }

      before do
        allow_any_instance_of(RequestController).to receive(:current_search_session).and_return(current_search)
      end

      it "renders the 'Back to search' button" do
        visit solr_document_request_success_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_link(I18n.t("blacklight.back_to_search", href: "/catalog"))
      end
    end

    context "when a catalogue search has not been performed" do
      it "does not render the 'Back to search' button" do
        visit solr_document_request_success_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("body")
        expect(page).to have_no_link(I18n.t("blacklight.back_to_search"))
      end
    end

    context "when user has reached their request limit" do
      it "renders the request limit error" do
        WebMock.stub_request(:get, /catservices.test\/catalogue-services\/folio\/user\/(.*)\/requestLimitReached/)
          .with(
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
            }
          )
          .to_return(status: 200, body: "{\"requestLimitReached\": \"true\"}", headers: {})

        visit solr_document_request_success_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_text("Your request limit has been reached")
      end
    end

    context "when pickup location is Special Collections Reading Room" do
      let(:item_id) { "60ae1cf9-5b4c-5fac-9a38-2cb195cdb7b2" }

      it "renders the special collections message" do
        visit solr_document_request_success_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )

        expect(page).to have_css("p",
          text: "To prepare for your visit, and find out more about use of and access to our special collections")
      end
    end
  end

  def serial_marc
    load_marc_from_file 1595553
  end

  def serial_manuscript_marc
    load_marc_from_file 2761
  end

  def map_marc
    load_marc_from_file 1832134
  end
end
