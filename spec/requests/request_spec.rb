require "rails_helper"

RSpec.describe "Requests" do
  before do
    user = create(:user)
    sign_in user
  end

  let(:solr_document_id) { "1595553" }
  let(:instance_id) { "08aed703-3648-54d0-80ef-fddb3c635731" }
  let(:holdings_id) { "37fbc2dd-3b37-58b8-b447-b538ba7265b9" }
  let(:item_id) { "60ae1cf9-5b4c-5fac-9a38-2cb195cdb7b2" }
  let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_marc, title_tsim: ["National Geographic"], format: ["Journal"]) }

  describe "GET /new" do
    context "when user is not logged in" do
      before do
        sign_out :user
      end

      it "redirects to login page" do
        get solr_document_request_new_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a catalogue services error occurs" do
      let(:holdings_id) { "fe525746-5142-5b54-8c89-c6ed7a9c6196" }
      let(:item_id) { "0f17532a-2fcf-5c72-a0c9-751fc459481f" }

      it "redirects to the error page" do
        allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])
        allow_any_instance_of(CatalogueServicesClient).to receive(:get_holding).and_raise(ServiceTokenError)

        expect {
          get solr_document_request_new_path(
            solr_document_id: solr_document_id,
            instance: instance_id,
            holdings: holdings_id,
            item: item_id
          )
          expect(response).to have_http_status(:internal_server_error)
        }.to raise_error(ServiceTokenError)
      end
    end
  end

  describe "GET /create" do
    let(:holdings_id) { "fe525746-5142-5b54-8c89-c6ed7a9c6196" }
    let(:item_id) { "0f17532a-2fcf-5c72-a0c9-751fc459481f" }

    it "returns http success" do
      allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])

      post solr_document_request_path(
        solr_document_id: solr_document_id,
        requester: "111",
        request: {
          holdings_id: holdings_id,
          item_id: item_id
        }
      )

      expect(response).to redirect_to(solr_document_request_success_path(solr_document_id: solr_document_id, holdings: holdings_id, item: item_id))

      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response.body).to include(I18n.t("requesting.success.message", request_summary_url: account_requests_path))
      expect(response.body).to include(I18n.t("requesting.success.collection"))
    end

    context "when a catalogue services error occurs" do
      it "redirects to the error page" do
        allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])
        allow_any_instance_of(CatalogueServicesClient).to receive(:get_holding).and_raise(ServiceTokenError)

        expect {
          post solr_document_request_path(
            solr_document_id: solr_document_id,
            requester: "111",
            request: {
              holdings_id: holdings_id,
              item_id: item_id
            }
          )
        }.to raise_error(ServiceTokenError)
      end
    end
  end

  def serial_marc
    load_marc_from_file 1595553
  end
end
