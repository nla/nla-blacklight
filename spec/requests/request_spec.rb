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
  let(:document) { SolrDocument.new(id: solr_document_id, marc_ss: serial_marc, title_tsim: "National Geographic") }

  describe "GET /new" do
    context "when requesting a monograph" do
      it "returns http success" do
        allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])

        get new_solr_document_request_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(response).to have_http_status(:success)
      end
    end

    context "when requesting a serial" do
      let(:holdings_id) { "fe525746-5142-5b54-8c89-c6ed7a9c6196" }
      let(:item_id) { "0f17532a-2fcf-5c72-a0c9-751fc459481f" }

      it "returns http success" do
        allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])

        get new_solr_document_request_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not logged in" do
      before do
        sign_out :user
      end

      it "redirects to login page" do
        get new_solr_document_request_path(
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

        get new_solr_document_request_path(
          solr_document_id: solr_document_id,
          instance: instance_id,
          holdings: holdings_id,
          item: item_id
        )
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  describe "GET /create" do
    let(:holdings_id) { "fe525746-5142-5b54-8c89-c6ed7a9c6196" }
    let(:item_id) { "0f17532a-2fcf-5c72-a0c9-751fc459481f" }

    it "returns http success" do
      allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])

      post solr_document_requests_path(
        solr_document_id: solr_document_id,
        requester: "111",
        request: {
          instance_id: instance_id,
          holdings_id: holdings_id,
          item_id: item_id
        }
      )
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Your request for <strong>National Geographic</strong> is currently being processed.")
    end

    context "when a catalogue services error occurs" do
      it "redirects to the error page" do
        allow_any_instance_of(Blacklight::SearchService).to receive(:fetch).with(any_args).and_return([nil, document])
        allow_any_instance_of(CatalogueServicesClient).to receive(:get_holding).and_raise(ServiceTokenError)

        post solr_document_requests_path(
          solr_document_id: solr_document_id,
          requester: "111",
          request: {
            instance_id: instance_id,
            holdings_id: holdings_id,
            item_id: item_id
          }
        )
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  end

  # describe "GET /show" do
  #   it "returns http success" do
  #     get "/catalog/1414519/request/show"
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  def serial_marc
    load_marc_from_file 1595553
  end
end
