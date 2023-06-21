require "rails_helper"

RSpec.describe "Accounts" do
  before do
    user = create(:user)
    sign_in user
  end

  describe "GET /requests" do
    before do
      record_result = IO.read("spec/files/account/record_search.json")
      WebMock.stub_request(:get, /solr:8983/)
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
          }
        )
        .to_return(status: 200, body: record_result, headers: {})
    end

    it "returns http success" do
      get account_requests_path
      expect(response).to have_http_status(:success)
    end

    context "when user is not logged in" do
      before do
        sign_out :user
      end

      it "redirects to login page" do
        get account_requests_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
